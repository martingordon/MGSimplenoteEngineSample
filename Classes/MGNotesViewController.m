//
//  MGNotesViewController.m
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MGNotesViewController.h"
#import "MGNoteDetailController.h"
#import "MGSimplenoteIndex.h"
#import "MGSimplenote.h"

@interface MGNotesViewController (Internal)

- (void)failure:(NSNotification *)notif;

@end


@implementation MGNotesViewController

@synthesize email, authToken;
@synthesize notes;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
		UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
		
		self.toolbarItems = [NSArray arrayWithObjects:refresh, space, add, nil];
		[refresh release];
		[space release];
		[add release];
    }
    return self;
}

- (void)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)refresh:(id)sender {
	MGSimplenoteIndex *index = [[MGSimplenoteIndex alloc] init];
	index.email = self.email;
	index.authToken = self.authToken;
	[index addObserver:self forSelector:@selector(pullFromRemote) success:@selector(indexSucceeded:) failure:@selector(failure:)];
	
	[index pullFromRemote];
}

- (void)add:(id)sender {
	MGNoteDetailController *detailController = [[MGNoteDetailController alloc] initWithNibName:nil bundle:nil];
	MGSimplenote *newNote = [[MGSimplenote alloc] init];
	newNote.email = self.email;
	newNote.authToken = self.authToken;
	detailController.note = newNote;
	[newNote release];
	
	[self.navigationController pushViewController:detailController animated:YES];
	[detailController release];
}


- (void)indexSucceeded:(NSNotification *)notif {
	NSArray *incomingNotes = [[[notif userInfo] objectForKey:@"MGSimplenoteIndex"] contents];
	NSMutableArray *notDeleted = [NSMutableArray arrayWithCapacity:[incomingNotes count]];

	for (MGSimplenote *note in incomingNotes) {
		if ([note.deleted boolValue] == NO) {
			[notDeleted addObject:note];
		}
	}
	self.notes = notDeleted;
	[self.tableView reloadData];
	
	for (MGSimplenote *note in self.notes) {
		note.email = self.email;
		note.authToken = self.authToken;
		
		if ([note.text length] == 0) {
			[note addObserver:self forSelector:@selector(pullFromRemote) success:@selector(notePullSuccess:) failure:@selector(failure:)];
			[note pullFromRemote];
		}
	}
}


- (void)notePullSuccess:(NSNotification *)notif {
	NSInteger index = [self.notes indexOfObject:[[notif userInfo] objectForKey:@"MGSimplenote"]];
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)noteDeleteSuccess:(NSNotification *)notif {
	NSMutableArray *newNotes = [self.notes mutableCopy];
	
	[newNotes removeObject:[[notif userInfo] objectForKey:@"MGSimplenote"]];
	self.notes = newNotes;
	[newNotes release];
	
	[self.tableView reloadData];
}

- (void)noteDeleteFailure:(NSNotification *)notif {
	[self failure:notif];
	[self.tableView reloadData];
}

- (void)failure:(NSNotification *)notif {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[[notif userInfo] objectForKey:@"error"] localizedDescription]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
	[self refresh:nil];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationController.toolbarHidden = NO;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.notes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	MGSimplenote *note = [self.notes objectAtIndex:indexPath.row];
	
	if ([note.text length] == 0) {
		cell.textLabel.text = note.key;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		NSString *str = nil;
		NSScanner *scanner = [NSScanner scannerWithString:note.text];
		[scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&str];
		NSInteger upto = ([str length] < 25 ? [str length] : 25);
		cell.textLabel.text = [str substringToIndex:upto];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;		
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	
	cell.detailTextLabel.text = [formatter stringFromDate:note.modifyDate];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		MGSimplenote *note = [self.notes objectAtIndex:indexPath.row];
		[note addObserver:self forSelector:@selector(deleteNote) success:@selector(noteDeleteSuccess:) failure:@selector(noteDeleteFailure:)];
		[note deleteNote];

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MGNoteDetailController *detailController = [[MGNoteDetailController alloc] initWithNibName:nil bundle:nil];
	
	detailController.note = [self.notes objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailController animated:YES];
	[detailController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end


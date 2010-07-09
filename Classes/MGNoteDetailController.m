    //
//  MGNoteDetailController.m
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MGNoteDetailController.h"
#import "MGSimplenote.h"

@implementation MGNoteDetailController

@synthesize note;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UITextView *aView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[textView release];
	textView = [aView retain];
	self.view = textView;
	[aView release];
}

- (void)viewWillAppear:(BOOL)animated {
	textView.text = self.note.text;
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem release];
}

- (void)save:(id)sender {
	self.note.text = textView.text;
	[self.note addObserver:self forSelector:@selector(pushToRemote) success:@selector(pushSucceeded:) failure:@selector(pushFailed:)];
	[self.note pushToRemote];
}

- (void)pushSucceeded:(NSNotification *)notif {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Your note was saved."
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)pushFailed:(NSNotification *)notif {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
	message:[NSString stringWithFormat:@"An error occurred trying to save the note:\n%@", [[notif userInfo] objectForKey:@"error"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textView release];
	[note release];
    [super dealloc];
}


@end

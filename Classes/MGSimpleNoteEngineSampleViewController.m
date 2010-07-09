//
//  MGSimpleNoteEngineSampleViewController.m
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MGSimpleNoteEngineSampleViewController.h"
#import "MGSimpleNoteLogin.h"
#import "MGNotesViewController.h"

@implementation MGSimpleNoteEngineSampleViewController

@synthesize emailField, passwordField, autologinSwitch, output, email, authToken;

- (void)viewWillAppear:(BOOL)animated {
	NSString *defaultEmail = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
	NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
	NSNumber *autoLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"autologin"];
	
	self.emailField.text = defaultEmail;
	self.passwordField.text = password;
	self.autologinSwitch.on = [autoLogin boolValue];
}

- (void)viewDidAppear:(BOOL)animated {
	if (self.autologinSwitch.on) {
		[self login:nil];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)login:(id)sender {
	MGSimplenoteLogin *login = [[MGSimplenoteLogin alloc] init];
	login.email = self.emailField.text;
	login.password = self.passwordField.text;
	[login addObserver:self forSelector:@selector(login) success:@selector(loginSucceeded:) failure:@selector(loginFailed:)];
	[login login];	
}

- (void)loginSucceeded:(NSNotification *)notif {
	output.text = [output.text stringByAppendingFormat:@"Login succeeded <%@>:\n%@\n\n", [NSDate date], notif];
	
	[[NSUserDefaults standardUserDefaults] setValue:self.emailField.text forKey:@"email"];
	[[NSUserDefaults standardUserDefaults] setValue:self.passwordField.text forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.autologinSwitch.on] forKey:@"autologin"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	self.email = ((MGSimplenoteLogin *)[[notif userInfo] objectForKey:@"MGSimplenoteLogin"]).email;
	self.authToken = ((MGSimplenoteLogin *)[[notif userInfo] objectForKey:@"MGSimplenoteLogin"]).authToken;
}

- (IBAction)loginFailed:(NSNotification *)notif {
	output.text = [output.text stringByAppendingFormat:@"Login failed <%@>:\n%@\n\n", [NSDate date], notif];
}


- (IBAction)showNotes:(id)sender {
	MGNotesViewController *notesViewController = [[MGNotesViewController alloc] initWithStyle:UITableViewStylePlain];
	notesViewController.email = self.email;
	notesViewController.authToken = self.authToken;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:notesViewController];
	[self presentModalViewController:navController animated:YES];
	
	[notesViewController release];
	[navController release];
}


- (void)dealloc {
	[emailField release];
	[passwordField release];
	[output release];
	[email release];
	[authToken release];
    [super dealloc];
}

@end

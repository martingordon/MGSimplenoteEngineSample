//
//  MGSimpleNoteEngineSampleAppDelegate.m
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MGSimpleNoteEngineSampleAppDelegate.h"
#import "MGSimpleNoteEngineSampleViewController.h"

@implementation MGSimpleNoteEngineSampleAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
	NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
	
	viewController.emailField.text = email;
	viewController.passwordField.text = password;
	
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] setValue:viewController.emailField.text forKey:@"email"];
	[[NSUserDefaults standardUserDefaults] setValue:viewController.passwordField.text forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

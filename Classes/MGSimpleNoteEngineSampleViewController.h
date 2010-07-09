//
//  MGSimpleNoteEngineSampleViewController.h
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGSimpleNoteEngineSampleViewController : UIViewController <UITextFieldDelegate> {
	UITextField *emailField, *passwordField;
	UISwitch *autologinSwitch;
	UITextView *output;
	
	NSString *email, *authToken;
}

@property (nonatomic, retain) IBOutlet UITextField *emailField, *passwordField;
@property (nonatomic, retain) IBOutlet UISwitch *autologinSwitch;
@property (nonatomic, retain) IBOutlet UITextView *output;
@property (nonatomic, copy) NSString *email, *authToken;

- (IBAction)login:(id)sender;
- (IBAction)showNotes:(id)sender;

@end


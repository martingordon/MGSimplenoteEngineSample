//
//  MGNoteDetailController.h
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGSimplenote;

@interface MGNoteDetailController : UIViewController {
	MGSimplenote *note;
	UITextView *textView;
}

@property (nonatomic, retain) MGSimplenote *note;

- (void)save:(id)sender;

@end

//
//  MGSimpleNoteEngineSampleAppDelegate.h
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGSimpleNoteEngineSampleViewController;

@interface MGSimpleNoteEngineSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MGSimpleNoteEngineSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MGSimpleNoteEngineSampleViewController *viewController;

@end


//
//  MGNotesViewController.h
//  MGSimpleNoteEngineSample
//
//  Created by Martin Gordon on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MGNotesViewController : UITableViewController {
	NSString *email, *authToken;
	NSArray *notes;
}

@property (nonatomic, copy) NSString *email, *authToken;
@property (nonatomic, retain) NSArray *notes;

@end

//
//  SettingsViewController.h
//  Improv
//
//  Created by Andrew Harrison on 4/19/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic, retain) MFMailComposeViewController *mailComposeViewController;
@end

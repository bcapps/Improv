//
//  FiltersTableViewController.h
//  Improv
//
//  Created by Andrew Harrison on 3/15/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiltersTableViewController : UITableViewController <UIActionSheetDelegate>
@property (nonatomic, strong) UIStepper *minStepper;
@property (nonatomic, strong) UIStepper *maxStepper;
@property (nonatomic, strong) UIButton *resetButton;
@end

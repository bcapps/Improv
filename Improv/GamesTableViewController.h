//
//  GamesTableViewController.h
//  Improv
//
//  Created by Andrew Harrison on 2/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

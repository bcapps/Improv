//
//  GamesTableViewController.h
//  Improv
//
//  Created by Andrew Harrison on 2/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "FiltersTableViewController.h"

@interface GamesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) NSTimeInterval timeAsInt;
@property (nonatomic, strong) Game *currentlyPlayingGame;
@property (nonatomic, strong) UIBarButtonItem *timerButton;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) NSFetchedResultsController *filteredResultsController;
@property (strong, nonatomic, readonly) NSFetchedResultsController *currentFetchedResultsController;
@property (strong, nonatomic) FiltersTableViewController *filtersTableViewController;
@end

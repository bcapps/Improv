//
//  GamesTableViewController.m
//  Improv
//
//  Created by Andrew Harrison on 2/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "GamesTableViewController.h"
#import "ImprovTableViewCell.h"
#import "Game.h"
#import "GameInfoTableViewController.h"
#import "FiltersTableViewController.h"
#import "TKAlertCenter.h"
#import "Suggestion.h"
#import "ImprovSingleton.h"

#define RANDOM_ACTION_SHEET_TAG 100
#define SUGGESTION_ACTION_SHEET_TAG 101

@implementation GamesTableViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize timer;
@synthesize timeAsInt;
@synthesize currentlyPlayingGame;
@synthesize timerButton;
@synthesize searchDisplayController;
@synthesize filteredResultsController = __filteredResultsController;
@synthesize currentFetchedResultsController;
@synthesize filtersTableViewController;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filtersTableViewController = [[FiltersTableViewController alloc] initWithStyle:UITableViewStyleGrouped];

    UIBarButtonItem *suggestionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lightbulb"] style:UIBarButtonItemStylePlain target:self action:@selector(suggestionButtonPushed)];
    
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"random"] style:UIBarButtonItemStylePlain target:self action:@selector(randomButtonPushed)];
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonPushed)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0f)];
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsTableView.rowHeight = 66.0f;
    self.searchDisplayController.searchResultsTableView.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = searchBar;
    
    UIButton *internalTimerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    [internalTimerButton setTitle:@"0:00" forState:UIControlStateNormal];
    internalTimerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    internalTimerButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    
    timerButton = [[UIBarButtonItem alloc] init];
    timerButton.style = UIBarButtonItemStyleBordered;
    timerButton.title = @"    0:00    ";
    [timerButton setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:16.0f] forKey:UITextAttributeFont] forState:UIControlStateNormal];
    [timerButton setTarget:self];
    [timerButton setAction:@selector(timerButtonPushed)];
    
    self.navigationItem.rightBarButtonItem = suggestionButton;
    
    self.toolbarItems = [NSArray arrayWithObjects:random,space,timerButton,space,filter, nil];

    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Games" style: UIBarButtonItemStyleBordered target: nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    self.navigationItem.title = @"Improv Games";
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    timeAsInt = -1;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)updateTimer {
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    UIBarButtonItem *timerButton = [items objectAtIndex:2];
    
    timeAsInt += 1;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeAsInt];
    
    NSString *dateFormat = @"    m:ss    ";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.dateFormat = dateFormat;
    timerButton.title = [dateFormatter stringFromDate:date];
}

- (void)suggestionButtonPushed {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Relationship", @"Location", @"Profession", nil];
    sheet.tag = SUGGESTION_ACTION_SHEET_TAG;
    
    [sheet showFromToolbar:self.navigationController.toolbar];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS [cd]%@", @"title", searchString]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.filteredResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.filteredResultsController.delegate = self;
    
	NSError *error = nil;
	if (![self.filteredResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    tableView.rowHeight = 66.0f;
    self.searchDisplayController.searchResultsTableView.delegate = self;
}

- (void)filterButtonPushed {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.filtersTableViewController];

    [self.navigationController presentModalViewController:navController animated:YES];
}

- (void)timerButtonPushed {
    UIBarButtonItem *timerButton = [self.toolbarItems objectAtIndex:2];
    NSString *time = [timerButton.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![time isEqualToString:@"0:00"]) {
        //[self.timer invalidate];
        //timerButton.title = @"    0:00    ";
        if([[[self navigationController] topViewController] isKindOfClass:[GameInfoTableViewController class]]) {
            GameInfoTableViewController *currentGameInfo = (GameInfoTableViewController *)[[self navigationController] topViewController];
            
            if([currentlyPlayingGame.gameDescription isEqualToString:currentGameInfo.game.gameDescription]) {
                return;
            }
        }

        GameInfoTableViewController *gameInfo = [[GameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        gameInfo.game = currentlyPlayingGame;
        
        [self.navigationController pushViewController:gameInfo animated:YES];
        
    }
    //timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    //timeAsInt = -1;
}

- (void)pauseTimer {
    
}

- (void)continueTimer {
    
}

- (void)randomButtonPushed {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Random Game", @"Random Filtered Game", nil];
    sheet.tag = RANDOM_ACTION_SHEET_TAG;
    [sheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == RANDOM_ACTION_SHEET_TAG) {
        if(buttonIndex == 0) {
            GameInfoTableViewController *gameInfo = [[GameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            gameInfo.game = [self.currentFetchedResultsController objectAtIndexPath:[self selectRandomGame]];
            [self.navigationController pushViewController:gameInfo animated:YES];
        }
        else if (buttonIndex == 1) {
            GameInfoTableViewController *gameInfo = [[GameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            gameInfo.game = [self.currentFetchedResultsController objectAtIndexPath:[self selectRandomGame]];
            [self.navigationController pushViewController:gameInfo animated:YES];
        }
    }
    else if(actionSheet.tag == SUGGESTION_ACTION_SHEET_TAG) {
        if(buttonIndex == actionSheet.cancelButtonIndex) {
            
        } else {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            // Edit the entity name as appropriate.
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Suggestion" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            
            
            if(buttonIndex == 0) {
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",@"type", @"Relationship"]];
                NSMutableArray *array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                
                NSString *relationship = ((Suggestion *)[array objectAtIndex:arc4random() % [array count]]).name;
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:relationship image:[UIImage imageNamed:@"relationship"]];
            } else if (buttonIndex == 1) {
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",@"type", @"Location"]];
                NSMutableArray *array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

                NSString *location = ((Suggestion *)[array objectAtIndex:arc4random() % [array count]]).name;
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:location image:[UIImage imageNamed:@"location"]];
            } else if (buttonIndex == 2) {
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",@"type", @"Profession"]];
                NSMutableArray *array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                
                NSString *profession = ((Suggestion *)[array objectAtIndex:arc4random() % [array count]]).name;
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:profession image:[UIImage imageNamed:@"profession"]];

            }
        }
    }
}

- (NSIndexPath *)selectRandomGame {
    int numberOfSections = [self numberOfSectionsInTableView:self.tableView];    
    int numberOfGames = [[self.currentFetchedResultsController fetchedObjects] count];
    int randomGame = arc4random() % numberOfGames;

    
    int count = 0;
    
    while(count < numberOfSections) {
        if(randomGame < [self.tableView numberOfRowsInSection:count]) {
            return [NSIndexPath indexPathForRow:randomGame inSection:count];
        }
        else {
            randomGame -= [self.tableView numberOfRowsInSection:count];
        }
        count++;
    }
    
    return 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UITableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell"; 
    ImprovTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ImprovTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = self.tableView.backgroundColor;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if([[self.currentFetchedResultsController sections] count] == 0) {
        return 1;
    }
    return [[self.currentFetchedResultsController sections] count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[self.currentFetchedResultsController fetchedObjects] count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.currentFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GameInfoTableViewController *gameInfo = [[GameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    gameInfo.game = [self.currentFetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:gameInfo animated:YES];

}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(self.currentFetchedResultsController == self.fetchedResultsController) {
        if([[self.currentFetchedResultsController fetchedObjects] count]) {
            Game *game = [self.currentFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            return [NSString stringWithFormat:@"%@ Players", game.minimumNumberOfPlayersString];
        }
    }
    return nil;
}

#pragma mark - Fetched Results Controller



- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    [NSFetchedResultsController deleteCacheWithName:@"Master"];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    NSNumber *minStepperValue = [NSNumber numberWithDouble:self.filtersTableViewController.minStepper.value];
    NSNumber *maxStepperValue = [NSNumber numberWithDouble:self.filtersTableViewController.maxStepper.value];

    if([minStepperValue doubleValue] == 0) {
        minStepperValue = [[ImprovSingleton sharedImprov] startingMin];
    }
    
    if([maxStepperValue doubleValue] == 0) {
        maxStepperValue = [[ImprovSingleton sharedImprov] startingMax];
    }    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K BETWEEN %@ && %K BETWEEN %@", @"minPlayers", arr, @"maxPlayers", arr]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K >= %f && ((%K == %f && %K <= %f) || (%K != %f && %K <= %f))", @"minPlayers", [minStepperValue floatValue], @"maxPlayers", 0.0f, @"minPlayers", [maxStepperValue floatValue], @"maxPlayers", 0.0f, @"maxPlayers", [maxStepperValue floatValue]]];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sectionSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minPlayers" ascending:YES];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sectionSortDescriptor, sortDescriptor, nil];

    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"minimumNumberOfPlayersString" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (NSFetchedResultsController *)currentFetchedResultsController {
    
    if(self.searchDisplayController.active) {
        return self.filteredResultsController;
    } 
    else {
        return self.fetchedResultsController;
    }
    
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ImprovTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(ImprovTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    Game *game = [self.currentFetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = game.title;
    cell.descriptionLabel.text = game.firstSentenceOfDescription;
    cell.imageView.image = [UIImage imageNamed:game.image];
    cell.imageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-white", game.image]];
    
}


@end

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

#define RANDOM_ACTION_SHEET_TAG 100

@implementation GamesTableViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *suggestionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lightbulb"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"random"] style:UIBarButtonItemStylePlain target:self action:@selector(randomButtonClicked)];
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *internalTimerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    [internalTimerButton setTitle:@"0:00" forState:UIControlStateNormal];
    internalTimerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    internalTimerButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    
    UIBarButtonItem *timerButton = [[UIBarButtonItem alloc] init];
    timerButton.style = UIBarButtonItemStyleBordered;
    timerButton.title = @"    0:00    ";
    [timerButton setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:16.0f] forKey:UITextAttributeFont] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = suggestionButton;
    
    self.toolbarItems = [NSArray arrayWithObjects:random,space,timerButton,space,filter, nil];

    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Games" style: UIBarButtonItemStyleBordered target: nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    self.navigationItem.title = @"Improv Games";
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)randomButtonClicked {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose Random Game" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Random Game", @"Random Game With Filters", nil];
    sheet.tag = RANDOM_ACTION_SHEET_TAG;
    [sheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag = RANDOM_ACTION_SHEET_TAG) {
        if(buttonIndex == 0) {
            GameInfoTableViewController *gameInfo = [[GameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            gameInfo.game = [self.fetchedResultsController objectAtIndexPath:[self selectRandomGame]];
            [self.navigationController pushViewController:gameInfo animated:YES];
        }
        else if (buttonIndex == 1) {

        }
    }
}

- (NSIndexPath *)selectRandomGame {
    int numberOfSections = [self numberOfSectionsInTableView:self.tableView];
    int randomSection = arc4random() % numberOfSections;
    
    return [NSIndexPath indexPathForRow:arc4random() % [self.tableView numberOfRowsInSection:randomSection] inSection:randomSection];
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
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GameInfoTableViewController *gameInfo = [[GameInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    gameInfo.game = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:gameInfo animated:YES];

}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Game *game = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    return [NSString stringWithFormat:@"%@ Players", game.minimumNumberOfPlayersString];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
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
    Game *game = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = game.title;
    cell.descriptionLabel.text = game.firstSentenceOfDescription;
    cell.imageView.image = [UIImage imageNamed:game.image];
    cell.imageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-white", game.image]];
}


@end

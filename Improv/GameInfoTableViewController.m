//
//  GameInfoTableViewController.m
//  Improv
//
//  Created by Andrew Harrison on 2/29/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "GameInfoTableViewController.h"
#import "GamesTableViewController.h"
#import "Game.h"
@interface GameInfoTableViewController ()

@end

@implementation GameInfoTableViewController
@synthesize game;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *suggestionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lightbulb"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 75)];
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-normal"] forState:UIControlStateNormal];
    [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-disabled"] forState:UIControlStateDisabled];
    [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-highlighted"] forState:UIControlStateHighlighted];
    playButton.frame = CGRectMake(10, 20, 300, 51);
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 51)];
    buttonLabel.text = @"Play Game";
    buttonLabel.textAlignment = UITextAlignmentCenter;
    buttonLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    buttonLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [playButton addSubview:buttonLabel];

    [containerView addSubview:playButton];
    self.tableView.tableHeaderView = containerView;
    
    self.navigationItem.rightBarButtonItem = suggestionButton;
    
    self.toolbarItems = ((UIViewController *)[self.navigationController.viewControllers objectAtIndex:0]).toolbarItems;
    
    self.title = game.title;
    
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Games" forState:UIControlStateNormal];
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    //[[self navigationItem] setBackBarButtonItem: backItem];
}

- (void)pop{
    
	BOOL didPop = NO;
	for (UIViewController *vC in self.navigationController.viewControllers){
		if ([vC isKindOfClass: [GamesTableViewController class]]){					
			[self.navigationController popToViewController:(UIViewController *)vC animated:YES];
			didPop = YES;
			break;
		}
	}
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

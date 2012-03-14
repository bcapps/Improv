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
@synthesize timeAsInt;

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
    [playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
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

- (void)playButtonTapped {
    timeAsInt = 0;
    NSTimeInterval interval = 1.0;
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    UIBarButtonItem *timerButton = [items objectAtIndex:2];
    
    if (game.timerType) {
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:interval target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        NSRunLoop *loop = [NSRunLoop mainRunLoop];
        [loop addTimer:timer forMode:NSRunLoopCommonModes];
        
    } else {

        timerButton.title = [NSString stringWithFormat:@"    %@    ", game.maxTime];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        NSString *cellText = game.gameDescription;
        UIFont *cellFont = [UIFont boldSystemFontOfSize:12.0f];
        CGSize constraintSize = CGSizeMake(200.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 10.0f;

    }
    return 44.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];

        if(indexPath.row == 0) {
            cell.textLabel.text = @"Description";
            cell.detailTextLabel.text = game.gameDescription;
            cell.detailTextLabel.numberOfLines = 0;
        }
        else if(indexPath.row == 1) {
            cell.textLabel.text = @"Players";
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            if(![game.maxPlayers intValue]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", game.minPlayers];
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", game.minPlayers, game.maxPlayers];
            }
        }
        else if(indexPath.row == 2) {
            cell.textLabel.text = @"Time";
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ minutes", game.minTime, game.maxTime];
        }
        else if(indexPath.row == 3) {
            cell.textLabel.text = @"Audience";
            if([game.audienceParticipation boolValue]) {
                cell.detailTextLabel.text = @"Yes";
            } else {
                cell.detailTextLabel.text = @"No";
            }
        }
        else if(indexPath.row == 4) {
            cell.textLabel.text = @"Tags";
            NSString *tagsString = [[NSString alloc] init];
            int count = 0;
            
            for(NSString *string in [game tagsAsStringsArray]) {
                if(count == 0) {
                    tagsString = [tagsString stringByAppendingFormat:@"%@", string];
                } else {
                    tagsString = [tagsString stringByAppendingFormat:@", %@", string];
                }
                count++;
            }
            cell.detailTextLabel.text = tagsString;
        }
    }
    // Configure the cell...
    cell.userInteractionEnabled = NO;
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

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
@synthesize playButton;
@synthesize buttonLabel;

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
    
    //UIBarButtonItem *suggestionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lightbulb"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 75)];
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-normal"] forState:UIControlStateNormal];
    [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-disabled"] forState:UIControlStateDisabled];
    [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-highlighted"] forState:UIControlStateHighlighted];
    playButton.frame = CGRectMake(10, 20, 300, 51);
    [playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 51)];
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
    
    self.navigationItem.rightBarButtonItem = ((UIViewController *)[self.navigationController.viewControllers objectAtIndex:0]).navigationItem.rightBarButtonItem;
    
    self.toolbarItems = ((UIViewController *)[self.navigationController.viewControllers objectAtIndex:0]).toolbarItems;

    self.title = game.title;
    
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Games" forState:UIControlStateNormal];
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    //[[self navigationItem] setBackBarButtonItem: backItem];
}

- (UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color {

    
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(bitmapContext, bounds, mask.CGImage);

    CGContextSetBlendMode (bitmapContext, kCGBlendModeMultiply);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);    
    CGContextFillRect(bitmapContext, bounds);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage:mainViewContentBitmapContext];
    return result;
}

- (void)playButtonTapped {
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    UIBarButtonItem *timerButton = [items objectAtIndex:2];
    GamesTableViewController *gamesTableViewController;
    
    for(UIViewController *vC in [[self navigationController] viewControllers]) {
        if ([vC isKindOfClass:[GamesTableViewController class]]) {
            gamesTableViewController = (GamesTableViewController *)vC;
        }
    }    
    
    if (game.timerType) {
        NSRunLoop *loop = [NSRunLoop mainRunLoop];
        [loop addTimer:gamesTableViewController.timer forMode:NSRunLoopCommonModes];
        
    } else {
        timerButton.title = [NSString stringWithFormat:@"    %@    ", game.maxTime];
    }
    
    if([buttonLabel.text isEqualToString:@"Stop Game"]) {
        [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-normal"] forState:UIControlStateNormal];
        [playButton setBackgroundImage:[UIImage imageNamed:@"glossyButton-highlighted"] forState:UIControlStateHighlighted];
        buttonLabel.text = @"Play Game";
        
        gamesTableViewController.currentlyPlayingGame = nil;
        [gamesTableViewController.timer invalidate];
        gamesTableViewController.timerButton.title = @"    0:00    ";
        gamesTableViewController.timeAsInt = -1;
        gamesTableViewController.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:gamesTableViewController selector:@selector(updateTimer) userInfo:nil repeats:YES];
        
    }
    else if(gamesTableViewController.currentlyPlayingGame == nil) {
        
        [playButton setBackgroundImage:[self newImageFromMaskImage:[UIImage imageNamed:@"glossyButton-normal-greyscale"] inColor:[UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:30.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [playButton setBackgroundImage:[self newImageFromMaskImage:[UIImage imageNamed:@"glossyButton-highlighted-greyscale"] inColor:[UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:30.0/255.0 alpha:1]] forState:UIControlStateHighlighted];
        buttonLabel.text = @"Stop Game";
        
        gamesTableViewController.currentlyPlayingGame = game;
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    GamesTableViewController *gamesTableViewController;
    
    for(UIViewController *vC in [[self navigationController] viewControllers]) {
        if ([vC isKindOfClass:[GamesTableViewController class]]) {
            gamesTableViewController = (GamesTableViewController *)vC;
        }
    } 
    
    if([gamesTableViewController.currentlyPlayingGame.gameDescription isEqualToString:self.game.gameDescription]) {
        [playButton setBackgroundImage:[self newImageFromMaskImage:[UIImage imageNamed:@"glossyButton-copy"] inColor:[UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:30.0/255.0 alpha:1]] forState:UIControlStateNormal];
        buttonLabel.text = @"Stop Game";
    }
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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UIFont *cellFont = cell.textLabel.font;
    CGSize constraintSize = CGSizeMake(cell.contentView.frame.size.width - 40.0f, MAXFLOAT);
    
    if(indexPath.row == 0) {
        NSString *cellText = game.gameDescription;
        
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 20.0f;

    } else if (indexPath.row == 4) {
        int count = 0;
        NSString *tagsString = nil;
        
        for(NSString *string in [game tagsAsStringsArray]) {
            if(count == 0) {
                tagsString = [tagsString stringByAppendingFormat:@"%@", string];
            } else {
                tagsString = [tagsString stringByAppendingFormat:@", %@", string];
            }
            count++;
        }    
        
        CGSize labelSize = [tagsString sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 44.0f;
    }
    return 44.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];

        if(indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.text = game.gameDescription;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        else if(indexPath.row == 1) {
            cell.textLabel.text = @"players";
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            if(![game.maxPlayers intValue]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", game.minPlayers];
            }
            else if(game.maxPlayers == game.minPlayers) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", game.minPlayers];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", game.minPlayers, game.maxPlayers];
            }
        }
        else if(indexPath.row == 2) {
            cell.textLabel.text = @"time";
            
            if(game.minTime == game.maxTime) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ minutes", game.minTime];
            } 
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ minutes", game.minTime, game.maxTime];
            }
        }
        else if(indexPath.row == 3) {
            cell.textLabel.text = @"audience";
            if([game.audienceParticipation boolValue]) {
                cell.detailTextLabel.text = @"Yes";
            } else {
                cell.detailTextLabel.text = @"No";
            }
        }
        else if(indexPath.row == 4) {
            cell.textLabel.text = @"tags";
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
            cell.detailTextLabel.numberOfLines = 0;
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

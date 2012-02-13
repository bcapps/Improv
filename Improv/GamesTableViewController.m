//
//  GamesTableViewController.m
//  Improv
//
//  Created by Andrew Harrison on 2/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "GamesTableViewController.h"

@implementation GamesTableViewController
@synthesize sortedGames;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];

    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dice"] style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *timerLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    [timerLabel setTitle:@"0:30" forState:UIControlStateNormal];
    
    UIBarButtonItem *timerButton = [[UIBarButtonItem alloc] initWithCustomView:timerLabel];
    
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lamp"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem = filter;
    
    self.toolbarItems = [NSArray arrayWithObjects:random,space,timerButton,space,add, nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ImprovGames" ofType:@"plist"];
    NSArray *games = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Games"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
    sortedGames = [games sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
	// Do any additional setup after loading the view, typically from a nib.
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
    NSDictionary *games = [sortedGames objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [games objectForKey:@"Title"];
    cell.detailTextLabel.text = [games objectForKey:@"Description"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortedGames count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

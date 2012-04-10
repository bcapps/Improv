//
//  FiltersTableViewController.m
//  Improv
//
//  Created by Andrew Harrison on 3/15/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "FiltersTableViewController.h"

@interface FiltersTableViewController ()

@end

@implementation FiltersTableViewController
@synthesize minStepper;
@synthesize maxStepper;
@synthesize resetButton;

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
        
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPushed)];
    
   [self.navigationItem setRightBarButtonItem:doneButton];
    self.navigationItem.title = @"Filters";
    
    self.resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.resetButton.frame = CGRectMake(70, 340, 180, 51);
    [self.resetButton setTitle:@"Reset Filters" forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.resetButton];
    
    //[playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];    
    
    self.minStepper = [[UIStepper alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115.0f, 10.0f, 0.0f, 0.0f)];
    self.maxStepper = [[UIStepper alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115.0f, 10.0f, 0.0f, 0.0f)];
    
    self.minStepper.minimumValue = 1;
    self.maxStepper.minimumValue = 1;
    
    self.minStepper.tag = 100;
    self.maxStepper.tag = 101;
    
    [self.minStepper setStepValue:1.0];
    [self.maxStepper setStepValue:1.0];
    self.minStepper.autorepeat = YES;
    self.maxStepper.autorepeat = YES;
    
    self.minStepper.value = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MinStepperValue"];
    self.maxStepper.value = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MaxStepperValue"];
    
    [self stepperValueChanged:self.minStepper];
    [self stepperValueChanged:self.maxStepper];

    [self.minStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.maxStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.tableView.allowsSelection = NO;
}

- (void)stepperValueChanged:(UIStepper *)stepper {
    if(stepper.tag == 100) {
        if(stepper.value > self.maxStepper.value) {
            stepper.value = self.maxStepper.value;
            [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MinStepperValue"];
            return;
        }
        NSNumber *value = [NSNumber numberWithDouble:self.minStepper.value];

        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text = [NSString stringWithFormat:@"%i", [value intValue]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MinStepperValue"];
        self.maxStepper.minimumValue = self.minStepper.value;

    } else if(stepper.tag == 101) {
        if(stepper.value < self.minStepper.value) {
            stepper.value = self.minStepper.value;
            [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MaxStepperValue"];
            return;
        }
        NSNumber *value = [NSNumber numberWithDouble:maxStepper.value];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text = [NSString stringWithFormat:@"%i", [value intValue]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MaxStepperValue"];
        self.minStepper.maximumValue = self.maxStepper.value;
    }
    
    [self.tableView reloadData];
}

- (void)resetButtonTapped {
    self.minStepper.value = 1;
    self.maxStepper.value = 15;
    
    [self stepperValueChanged:self.minStepper];
    [self stepperValueChanged:self.maxStepper];
}

- (void)doneButtonPushed {
    [self dismissModalViewControllerAnimated:YES];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Players";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"min";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:@"MinStepperValue"]];
        
        [cell addSubview:self.minStepper];

    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"max";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:@"MaxStepperValue"]];
        [cell addSubview:self.maxStepper];
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

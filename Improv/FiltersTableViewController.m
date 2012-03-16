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
    
    minStepper = [[UIStepper alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115.0f, 10.0f, 0.0f, 0.0f)];
    maxStepper = [[UIStepper alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115.0f, 10.0f, 0.0f, 0.0f)];
    
    minStepper.minimumValue = 1;
    maxStepper.minimumValue = 1;
    
    minStepper.tag = 100;
    maxStepper.tag = 101;
    
    [minStepper setStepValue:1.0];
    [maxStepper setStepValue:1.0];
    
    minStepper.value = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MinStepperValue"];
    maxStepper.value = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MaxStepperValue"];
    
    [self stepperValueChanged:minStepper];
    [self stepperValueChanged:maxStepper];

    [minStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [maxStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.tableView.allowsSelection = NO;
    
    //[navBar addSubview:doneButton];
    
    //[toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)stepperValueChanged:(UIStepper *)stepper {
    if(stepper.tag == 100) {
        if(stepper.value > maxStepper.value) {
            stepper.value = maxStepper.value;
            [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MinStepperValue"];
            return;
        }
        NSNumber *value = [NSNumber numberWithDouble:minStepper.value];

        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text = [NSString stringWithFormat:@"%i", [value intValue]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MinStepperValue"];

    } else if(stepper.tag == 101) {
        if(stepper.value < minStepper.value) {
            stepper.value = minStepper.value;
            [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MaxStepperValue"];
            return;
        }
        NSNumber *value = [NSNumber numberWithDouble:maxStepper.value];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text = [NSString stringWithFormat:@"%i", [value intValue]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"MaxStepperValue"];
    }
    
    [self.tableView reloadData];
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
        
        [cell addSubview:minStepper];

    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"max";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:@"MaxStepperValue"]];
        [cell addSubview:maxStepper];
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

//
//  AppDelegate.m
//  Improv
//
//  Created by Andrew Harrison on 2/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "AppDelegate.h"

#import "GamesTableViewController.h"
#import "Game.h"
#import "Tag.h"
#import "Suggestion.h"
#include <QuartzCore/QuartzCore.h>


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize sortedGames;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    GamesTableViewController *tableViewController = [[GamesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.managedObjectContext = self.managedObjectContext;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    navController.toolbarHidden = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    //[self importSuggestionData];
    //[self importGameData];
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"MinStepperValue"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MinStepperValue"];
    }
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"MaxStepperValue"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"MaxStepperValue"];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Core Data

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ImprovModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Improv.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) importSuggestionData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Suggestions" ofType:@"plist"];
    NSArray *relationships = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Relationships"];
    for(NSString *obj in relationships) {
        Suggestion *suggestion = [NSEntityDescription insertNewObjectForEntityForName:@"Suggestion" inManagedObjectContext:self.managedObjectContext];
        suggestion.name = obj;
        suggestion.type = @"Relationship";
    }
    
    NSArray *locations = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Locations"];
    for(NSString *obj in locations) {
        Suggestion *suggestion = [NSEntityDescription insertNewObjectForEntityForName:@"Suggestion" inManagedObjectContext:self.managedObjectContext];
        suggestion.name = obj;
        suggestion.type = @"Location";
    } 
    
    NSArray *professions = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Professions"];
    for(NSString *obj in professions) {
        Suggestion *suggestion = [NSEntityDescription insertNewObjectForEntityForName:@"Suggestion" inManagedObjectContext:self.managedObjectContext];
        suggestion.name = obj;
        suggestion.type = @"Profession";
    }    
    
    [self.managedObjectContext save:nil];
}

- (void) importGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ImprovGames" ofType:@"plist"];
    NSArray *games = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Games"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
    sortedGames = [games sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    for(NSDictionary *dictionary in sortedGames) {
        Game *game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
        
        game.image = [dictionary objectForKey:@"Image"];
        game.title = [dictionary objectForKey:@"Title"];
        game.gameDescription = [dictionary objectForKey:@"Description"];
        //game.tagArray = [[NSMutableArray alloc] init];
        for(NSManagedObject *obj in [dictionary objectForKey:@"Tags"]) {
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *detailsEntity=[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:detailsEntity];
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K like %@", @"name",[obj description]]];
            
            NSArray *fetchArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            
            if ([fetchArray count] > 0) {
                [game addTagsObject:[fetchArray objectAtIndex:0]];
            } 
            else {
                Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
                tag.name = [obj description];
                [game addTagsObject:tag];
            }

        }
        
        game.timerType = [dictionary objectForKey:@"timerCountsUp"];
        game.minPlayers = [dictionary objectForKey:@"MinPlayers"];
        game.maxPlayers = [dictionary objectForKey:@"MaxPlayers"];
        game.buzzer = [dictionary objectForKey:@"Buzzer"];
        game.minTime = [dictionary objectForKey:@"MinTime"];
        game.maxTime = [dictionary objectForKey:@"MaxTime"];
        game.rating = [dictionary objectForKey:@"Rating"];
        game.audienceParticipation = [dictionary objectForKey:@"AudienceParticipation"];
        //game.variations =
    }
    
    [self.managedObjectContext save:nil];
}


@end

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
#import "TestFlight.h"
#import "ImprovSingleton.h"
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
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"MinStepperValue"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MinStepperValue"];
    }
    else {
        [[ImprovSingleton sharedImprov] setStartingMin:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"MinStepperValue"]]];
    }
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"MaxStepperValue"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"MaxStepperValue"];
    }
    else {
        [[ImprovSingleton sharedImprov] setStartingMax:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"MaxStepperValue"]]];    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ImprovGames" ofType:@"plist"];
    NSString *version = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Version"];
    
    if(![[[NSUserDefaults standardUserDefaults] stringForKey:@"Version"] isEqualToString:version]) {
        NSError *error = nil;
        NSPersistentStore *store = [[self.persistentStoreCoordinator persistentStores] objectAtIndex:0];

        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Improv.sqlite"];
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        [coordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];

        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }        
        
        [self importSuggestionData];
        [self importGameData];
        [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"Version"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *arr = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if(![[[ImprovSingleton sharedImprov] tagsArray] count]) {
        for(Tag *tag in arr) {
            [[[ImprovSingleton sharedImprov] tagsArray] addObject:tag];        
        }      
        
        [[ImprovSingleton sharedImprov] setTagsArray:[[[[ImprovSingleton sharedImprov] tagsArray] sortedArrayUsingComparator:^NSComparisonResult(Tag *obj1, Tag *obj2) {
            return [obj1.name localizedStandardCompare:obj2.name];
        }] mutableCopy]];
        
    }
    
    GamesTableViewController *tableViewController = [[GamesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.callConfigureCell = YES;
    tableViewController.managedObjectContext = self.managedObjectContext;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    navController.toolbarHidden = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    #ifdef CONFIGURATION_Beta
        [TestFlight takeOff:@"b6ff894ad79974e300c096c44c7180d1_MzY0MTk4MjAxMi0wMy0yMCAxNToxNjozNS4xNTA3MDI"];
    #endif
    

    

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
    [self.managedObjectContext save:nil];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.managedObjectContext save:nil];

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
    [self.managedObjectContext save:nil];
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
                tag.isSelected = YES;
                [tag addGameObject:game];
                [game addTagsObject:tag];
            }
        }
        
        [game setHasSelectedTag:YES];
        
        game.firstSentenceDescription = [game firstSentenceOfDescriptionUsingOrthography:[NSOrthography orthographyWithDominantScript:@"Latn" languageMap:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"en"] forKey:@"Latn"]]];
        
        game.timerType = [dictionary objectForKey:@"timerCountsUp"];
        game.minPlayers = [dictionary objectForKey:@"MinPlayers"];
        game.maxPlayers = [dictionary objectForKey:@"MaxPlayers"];
        
        if([game.maxPlayers doubleValue] > [[NSUserDefaults standardUserDefaults] doubleForKey:@"MaxCountValue"]) {
            [[NSUserDefaults standardUserDefaults] setDouble:[game.maxPlayers doubleValue] forKey:@"MaxCountValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if([game.minPlayers doubleValue] > [[NSUserDefaults standardUserDefaults] doubleForKey:@"MaxCountValue"]) {
            [[NSUserDefaults standardUserDefaults] setDouble:[game.minPlayers doubleValue] forKey:@"MaxCountValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }       
    
        
        
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

//
//  AppDelegate.h
//  Improv
//
//  Created by Andrew Harrison on 2/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GamesTableViewController;

@interface AppDelegate : UINavigationController <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GamesTableViewController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSArray *sortedGames;

@end

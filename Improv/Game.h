//
//  Game.h
//  Improv
//
//  Created by Andrew Harrison on 2/28/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * gameDescription;
@property (nonatomic, retain) NSNumber * maxPlayers;
@property (nonatomic, retain) NSNumber * minPlayers;
@property (nonatomic, retain) NSNumber * minTime;
@property (nonatomic, retain) NSNumber * maxTime;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * audienceParticipation;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * buzzer;
@property (nonatomic, retain) NSNumber * timerType;
@property (nonatomic, retain) NSString * alternateNames;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSManagedObject *tags;
@property (nonatomic, retain) Game *similarGames;

@end

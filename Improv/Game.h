//
//  Game.h
//  Improv
//
//  Created by Andrew Harrison on 3/14/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Tag;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * alternateNames;
@property (nonatomic, retain) NSNumber * audienceParticipation;
@property (nonatomic, retain) NSNumber * buzzer;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * gameDescription;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * maxPlayers;
@property (nonatomic, retain) NSNumber * maxTime;
@property (nonatomic, retain) NSString * minimumNumberOfPlayersString;
@property (nonatomic, retain) NSNumber * minPlayers;
@property (nonatomic, retain) NSNumber * minTime;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * timerType;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Game *similarGames;
@property (nonatomic, retain) NSSet *tags;

- (NSString *)firstSentenceOfDescriptionUsingOrthography:(NSOrthography *)stringOrthography;
- (NSString *)minimumNumberOfPlayersString;
@property (nonatomic, retain) NSMutableArray *tagsAsStringsArray;


@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

//
//  Game.m
//  Improv
//
//  Created by Andrew Harrison on 2/28/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "Game.h"
#import "Game.h"


@implementation Game

@dynamic title;
@dynamic gameDescription;
@dynamic maxPlayers;
@dynamic minPlayers;
@dynamic minTime;
@dynamic maxTime;
@dynamic rating;
@dynamic audienceParticipation;
@dynamic favorite;
@dynamic alternateNames;
@dynamic tags;
@dynamic similarGames;
@dynamic image;
@dynamic timerType;
@dynamic buzzer;


- (NSString *)minimumNumberOfPlayersString {
    [self willAccessValueForKey:@"minimumNumberOfPlayersString"];
    NSString *playersString = [[NSString alloc] initWithFormat:@"%i", [self.minPlayers intValue]];
    [self didAccessValueForKey:@"minimumNumberOfPlayersString"];
    return playersString; 
}

@end

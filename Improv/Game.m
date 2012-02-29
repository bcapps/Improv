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
@synthesize firstSentenceOfDescription;

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

- (NSString *)firstSentenceOfDescription {
    __block NSString *firstSentence = nil;
    __block int blockCount = 0;
    NSRange stringRange = [self.gameDescription rangeOfString:self.gameDescription];
    NSString *stringScheme = NSLinguisticTagSchemeTokenType;
    NSOrthography *stringOrthography = [NSOrthography orthographyWithDominantScript:@"Latn" languageMap:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"en"] forKey:@"Latn"]];
    [self.gameDescription enumerateLinguisticTagsInRange:stringRange scheme:stringScheme options:0 orthography:stringOrthography usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
        if(blockCount == 0) {
            firstSentence = [self.gameDescription substringWithRange:sentenceRange];
            blockCount++;
        }
    }];
    
    return firstSentence;
}

@end

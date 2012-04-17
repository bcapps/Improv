//
//  Game.m
//  Improv
//
//  Created by Andrew Harrison on 3/14/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "Game.h"
#import "Tag.h"


@implementation Game

@dynamic alternateNames;
@dynamic audienceParticipation;
@dynamic buzzer;
@dynamic favorite;
@dynamic gameDescription;
@dynamic image;
@dynamic maxPlayers;
@dynamic maxTime;
@dynamic minimumNumberOfPlayersString;
@dynamic minPlayers;
@dynamic minTime;
@dynamic rating;
@dynamic timerType;
@dynamic title;
@dynamic similarGames;
@dynamic tags;
@synthesize tagsAsStringsArray;
//@synthesize firstSentenceOfDescriptionUsingOrthography;


- (NSString *)minimumNumberOfPlayersString {
    [self willAccessValueForKey:@"minimumNumberOfPlayersString"];
    NSString *playersString = [[NSString alloc] initWithFormat:@"%i", [self.minPlayers intValue]];
    [self didAccessValueForKey:@"minimumNumberOfPlayersString"];
    return playersString; 
}
- (NSString *)firstSentenceOfDescriptionUsingOrthography:(NSOrthography *)stringOrthography {

    __block NSString *firstSentence = nil;
    __block int blockCount = 0;
    NSRange stringRange = [self.gameDescription rangeOfString:self.gameDescription];
    NSString *stringScheme = NSLinguisticTagSchemeTokenType;

    [self.gameDescription enumerateLinguisticTagsInRange:stringRange scheme:stringScheme options:0 orthography:stringOrthography usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
        if(blockCount == 0) {
            firstSentence = [self.gameDescription substringWithRange:sentenceRange];
            blockCount++;
        }
    }];

    return firstSentence;
}

- (NSMutableArray*)tagsAsStringsArray {
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for(Tag *t in self.tags) {
        [stringArray addObject:t.name];
    }
    return stringArray;
}

@end

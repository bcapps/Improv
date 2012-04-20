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
@dynamic hasSelectedTag;
@dynamic firstSentenceDescription;
@synthesize tagsAsStringsArray;
//@synthesize firstSentenceOfDescriptionUsingOrthography;

- (BOOL)hasSelectedTag {
    for (Tag *tag in self.tags) {
        if(tag.isSelected) {
            return YES;
            break;
        }
    }
    
    return NO;
}

- (NSString *)minimumNumberOfPlayersString {     [self willAccessValueForKey:@"minimumNumberOfPlayersString"];
    NSString *playersString = [[NSString alloc] initWithFormat:@"%i", [self.minPlayers intValue]];
    [self didAccessValueForKey:@"minimumNumberOfPlayersString"];
    return playersString; 
}
- (NSString *)firstSentenceOfDescriptionUsingOrthography:(NSOrthography *)stringOrthography {

    __block NSString *description = nil;
    __block int blockCount = 0;
    NSRange stringRange = [self.gameDescription rangeOfString:self.gameDescription];
    NSString *stringScheme = NSLinguisticTagSchemeTokenType;

    if(![self.firstSentenceDescription length]) {
        [self.gameDescription enumerateLinguisticTagsInRange:stringRange scheme:stringScheme options:0 orthography:stringOrthography usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
            if(blockCount == 0) {
            description = [self.gameDescription substringWithRange:sentenceRange];
            blockCount++;
            }
        }];
    }

    return description;
}

- (NSMutableArray*)tagsAsStringsArray {
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for(Tag *t in self.tags) {
        [stringArray addObject:t.name];
    }
    return stringArray;
}

@end

//
//  Tag.h
//  Improv
//
//  Created by Andrew Harrison on 2/28/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Game *games;

@end

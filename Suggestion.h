//
//  Suggestion.h
//  Improv
//
//  Created by Andrew Harrison on 3/15/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Suggestion : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;

@end

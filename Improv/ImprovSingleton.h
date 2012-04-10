//
//  ImprovSingleton.h
//  Improv
//
//  Created by Andrew Harrison on 4/10/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImprovSingleton : NSObject {
    
}
+ (id)sharedImprov;

@property (nonatomic, retain) NSNumber *startingMin;
@property (nonatomic, retain) NSNumber *startingMax;

@end

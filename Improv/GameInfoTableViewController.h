//
//  GameInfoTableViewController.h
//  Improv
//
//  Created by Andrew Harrison on 2/29/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Game;
@interface GameInfoTableViewController : UITableViewController
@property (nonatomic, strong) Game *game;
@end

//
//  CRosterViewController.h
//  comp
//
//  Created by Jeff Miller on 4/21/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerDelegate <NSObject>

- (void) addGoal: (NSMutableDictionary*)player;
- (void) removeGoal: (NSMutableDictionary*)player;

@end

@interface CRosterViewController : UITableViewController<NSURLConnectionDataDelegate,PlayerDelegate>

@property (strong, nonatomic) NSMutableDictionary *game;

@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSMutableArray *homePlayers;
@property (strong, nonatomic) NSMutableArray *awayPlayers;

- (id)initWithStyle:(UITableViewStyle)style game:(NSMutableDictionary*)game;

@end

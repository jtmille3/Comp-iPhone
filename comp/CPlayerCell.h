//
//  CPlayerCell.h
//  comp
//
//  Created by Jeff Miller on 4/21/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRosterViewController.h"

@interface CPlayerCell : UITableViewCell

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *removeButton;
@property (strong, nonatomic) UILabel *goalsLabel;
@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) NSMutableDictionary* player;

@property (strong, nonatomic) id<PlayerDelegate> delegate;

- (void)render:(NSMutableDictionary*)player delegate:(id<PlayerDelegate>)delegate;
- (IBAction) addGoal:(id)sender;
- (IBAction) removeGoal:(id)sender;

@end

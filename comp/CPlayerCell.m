//
//  CPlayerCell.m
//  comp
//
//  Created by Jeff Miller on 4/21/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "CPlayerCell.h"

@implementation CPlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 6, 32, 32)];
        [self.addButton setImage:[UIImage imageNamed:@"plus-5-m.png"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addGoal:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.addButton];
        
        self.goalsLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 6, 32, 32)];
        self.goalsLabel.textAlignment = NSTextAlignmentCenter;
        self.goalsLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
        [self addSubview:self.goalsLabel];
        
        self.removeButton = [[UIButton alloc] initWithFrame:CGRectMake(66, 6, 32, 32)];
        [self.removeButton setImage:[UIImage imageNamed:@"minus-5-m.png"] forState:UIControlStateNormal];
        [self.removeButton addTarget:self action:@selector(removeGoal:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.removeButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 6, 218, 32)];
        self.goalsLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)render:(NSMutableDictionary*)player delegate:(id<PlayerDelegate>)delegate {
    self.player = player;
    self.delegate = delegate;
    
    self.goalsLabel.text = [NSString stringWithFormat:@"%@",[self.player valueForKey:@"goals"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[self.player valueForKey:@"player"]];
}

- (IBAction) addGoal:(id)sender
{
    NSNumber *goals = [self.player valueForKey:@"goals"];
    [self.player setValue:[NSNumber numberWithInt:[goals integerValue] + 1] forKey:@"goals"];
    [self.delegate addGoal:self.player];
}

- (IBAction) removeGoal:(id)sender
{
    NSNumber *goals = [self.player valueForKey:@"goals"];
    [self.player setValue:[NSNumber numberWithInt:[goals integerValue] - 1] forKey:@"goals"];
    [self.delegate removeGoal:self.player];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
}

@end

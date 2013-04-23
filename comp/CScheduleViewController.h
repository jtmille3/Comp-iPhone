//
//  CScheduleViewController.h
//  comp
//
//  Created by Jeff Miller on 4/22/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "KalViewController.h"

@interface CScheduleViewController : KalViewController<NSURLConnectionDataDelegate,KalDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSArray *json;
@property (strong, nonatomic) NSMutableArray *games;

@end

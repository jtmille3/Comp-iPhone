//
//  CAppDelegate.h
//  comp
//
//  Created by Jeff Miller on 4/20/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kal.h"

@interface CAppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate,KalDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KalViewController *calendarController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSArray *json;
@property (strong, nonatomic) NSMutableArray *games;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

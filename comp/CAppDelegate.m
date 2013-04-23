//
//  CAppDelegate.m
//  comp
//
//  Created by Jeff Miller on 4/20/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "CAppDelegate.h"

#import "CScheduleViewController.h"

@implementation CAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    self.navigationController = [[UINavigationController alloc] init];
    self.window.rootViewController = self.navigationController;
    
    CScheduleViewController *scheduleController = [[CScheduleViewController alloc] init];
    [self.navigationController pushViewController:scheduleController animated:YES];
    
    return YES;
}
	
@end

//
//  CSettingsViewController.h
//  comp
//
//  Created by Jeff Miller on 4/22/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSettingsViewController : UINavigationController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) UITableViewController *tableController;
@property (strong, nonatomic) NSString* host;
@property (nonatomic) BOOL clearCache;

@end

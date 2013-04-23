//
//  CSettingsViewController.m
//  comp
//
//  Created by Jeff Miller on 4/22/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "CSettingsViewController.h"

@interface CSettingsViewController ()

@end

@implementation CSettingsViewController

- (id)init
{
    self = [super init];
    if (self) {
        UITableViewController* controller = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller.title = @"Settings";
        controller.tableView.delegate = self;
        controller.tableView.dataSource = self;
        
        controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        [self pushViewController:controller animated:NO];
    }
    return self;
}

- (IBAction) done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Server";
    else
        return @"Cache";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end

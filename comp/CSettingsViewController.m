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
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.host = [defaults stringForKey:@"host"];
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
        return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Server"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Server"];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 12, 216, 32)];
            textField.placeholder = @"http://localhost:8080";
            textField.text = self.host;
            textField.autocapitalizationType = NO;
            textField.autocorrectionType = NO;
            textField.delegate = self;
            [cell addSubview:textField];
        }
        
        cell.textLabel.text = @"Host";
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cache"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cache"];
        }
        
        cell.textLabel.text = @"Clear Cache";
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Clear Cache");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.host = textField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.host forKey:@"host"];
    [defaults synchronize];
}

@end

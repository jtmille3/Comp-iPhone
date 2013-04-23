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
        self.clearCache = YES;
        
        self.tableController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        self.tableController.title = @"Settings";
        self.tableController.tableView.delegate = self;
        self.tableController.tableView.dataSource = self;
        
        self.tableController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        [self pushViewController:self.tableController animated:NO];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.host = [defaults stringForKey:@"host"];
        
        if(!self.host) {
            [self.tableController.navigationItem.leftBarButtonItem setEnabled:NO];
        }
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
    if(self.clearCache) {
        self.clearCache = NO;
        
        [self.tableController.navigationItem.leftBarButtonItem setEnabled:NO];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *host = [defaults valueForKey:@"host"];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/service/cache/reset", host]]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.host = textField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.host forKey:@"host"];
    [defaults synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string && [string length] > 0) {
        [self.tableController.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    
    return YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.clearCache = YES;
    [self.tableController.tableView reloadData];
    [self.tableController.navigationItem.leftBarButtonItem setEnabled:YES];
}

@end

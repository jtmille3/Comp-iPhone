//
//  CScheduleViewController.m
//  comp
//
//  Created by Jeff Miller on 4/22/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "CScheduleViewController.h"
#import "CRosterViewController.h"

@interface CScheduleViewController ()

@end

@implementation CScheduleViewController

#pragma mark NSURLConnection

- (void) viewDidLoad
{
    self.buffer = [[NSMutableData alloc] init];
    self.dataSource = self;
    self.delegate = self;
    self.title = @"Soccer Calendar";
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/service/games"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    self.json = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [self reloadData];
    }
}

#pragma mark KalDataSource

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    [delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    if(!self.json) {
        return nil;
    }
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    const NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"MM/dd/yy hh:mm"];
    
    for(const NSDictionary *value in self.json) {
        //id value = [self.json valueForKey:key];
        NSDate *date = [fmt dateFromString:[value valueForKey:@"played"]];
        [dates addObject:date];
    }
    
    return dates;
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    if(!self.json) {
        self.games = nil;
        return;
    }
    
    self.games = [[NSMutableArray alloc] init];
    NSDate *selectedDate = [self selectedDate];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"MM/dd/yy hh:mm"];
    
    for(const NSDictionary *value in self.json) {
        NSDate *date = [fmt dateFromString:[value valueForKey:@"played"]];
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:flags fromDate:date];
        NSDate* dateOnly = [calendar dateFromComponents:components];
        
        if([selectedDate isEqualToDate:dateOnly]) {
            [self.games addObject: value];
        }
    }
}

- (void)removeAllItems
{
    
}

#pragma mark UITableViewDelegate protocol conformance

// Display a details screen for the selected holiday/row.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *game = [self.games objectAtIndex:indexPath.item];
    CRosterViewController *rosterViewController = [[CRosterViewController alloc] initWithStyle:UITableViewStylePlain game:game];
    [self.navigationController pushViewController:rosterViewController animated:YES];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSDictionary *game = [self.games objectAtIndex:indexPath.item];
    
    static NSString* CellIdentifier = @"Game";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *home = [game valueForKey:@"home"];
    NSString *away = [game valueForKey:@"away"];
    
    NSNumber *homeScore = [game valueForKey:@"homeScore"];
    NSNumber *awayScore = [game valueForKey:@"awayScore"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ vs %@", home, away];
    NSNumber *available = [game valueForKey:@"available"];
    if([available boolValue]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", homeScore, awayScore];
    } else {
        cell.detailTextLabel.text = @"TBD";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.json) {
        return 0;
    }
    
    return [self.games count];
}

@end

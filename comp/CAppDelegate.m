//
//  CAppDelegate.m
//  comp
//
//  Created by Jeff Miller on 4/20/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "CAppDelegate.h"

#import "CRosterViewController.h"

@implementation CAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.buffer = [[NSMutableData alloc] init];
    // Override point for customization after application launch.

    self.navigationController = [[UINavigationController alloc] init];
    self.window.rootViewController = self.navigationController;
    
    self.calendarController = [[KalViewController alloc] init];
    self.calendarController.dataSource = self;
    self.calendarController.delegate = self;
    self.calendarController.title = @"Soccer Calendar";
    [self.navigationController pushViewController:self.calendarController animated:YES];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/service/games"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void) saveContext {
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark NSURLConnection

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
        [self.calendarController reloadData];
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
    NSDate *selectedDate = [self.calendarController selectedDate];
    
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

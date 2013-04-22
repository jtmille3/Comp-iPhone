//
//  CRosterViewController.m
//  comp
//
//  Created by Jeff Miller on 4/21/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import "CRosterViewController.h"
#import "CPlayerCell.h"

@interface CRosterViewController ()
- (void) played;
- (void) updateGoalForPlayer:(NSNumber*)playerId game:(NSNumber*)gameId method:(NSString*)method;
@end

@implementation CRosterViewController

- (id)initWithStyle:(UITableViewStyle)style game:(NSMutableDictionary*)game
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Rosters";
        
        self.game = game;
        self.buffer = [[NSMutableData alloc] init];
        NSNumber* gameId = [self.game valueForKey:@"gameId"];
        
        NSMutableArray *homePlayers = [self.game valueForKey:@"homePlayers"];
        NSMutableArray *awayPlayers = [self.game valueForKey:@"awayPlayers"];
        
        if(!homePlayers || !awayPlayers) {
            NSString* url = [NSString stringWithFormat:@"http://localhost:8080/service/games/%@/players", gameId];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [connection start];
            
            [self.game setValue:[NSNumber numberWithBool:YES] forKey:@"available"];
            /*
            [self played];
             */
        } else {
            self.homePlayers = homePlayers;
            self.awayPlayers = awayPlayers;
            [self.tableView reloadData];
        }
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        NSString* home = [self.game valueForKey:@"home"];
        NSNumber* homeScore = [self.game valueForKey:@"homeScore"];
        return [NSString stringWithFormat:@"(%@) %@", homeScore, home];
    } else {
        NSString* home = [self.game valueForKey:@"away"];
        NSNumber* homeScore = [self.game valueForKey:@"awayScore"];
        return [NSString stringWithFormat:@"(%@) %@", homeScore, home];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.homePlayers && !self.awayPlayers) {
        return 0;
    }
    
    if(section == 0) {
        return [self.homePlayers count];
    } else {
        return [self.awayPlayers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* roster = indexPath.section == 0 ? self.homePlayers : self.awayPlayers;
    NSMutableDictionary* player = [roster objectAtIndex:indexPath.item];
    
    static NSString *CellIdentifier = @"Player";
    CPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[CPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell render:player delegate:self];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
}

#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary* rosters = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        self.homePlayers = [[NSMutableArray alloc] init];
        NSNumber* homeId = [self.game valueForKey:@"homeId"];
        NSNumber* homeScoreNumber = [self.game valueForKey:@"homeScore"];
        NSInteger homeScore = [homeScoreNumber integerValue];
        for(NSDictionary* player in rosters) {
            NSNumber* teamId = [player valueForKey:@"teamId"];
            if([teamId integerValue] == [homeId integerValue]) {
                [self.homePlayers addObject:player];
                NSNumber *goals = [player valueForKey:@"goals"];
                homeScore = homeScore - [goals integerValue];
            }
        }
        
        NSMutableDictionary* homeGhost = [NSMutableDictionary dictionary];
        [homeGhost setValue:@"Ghost" forKey:@"player"];
        [homeGhost setValue:[NSNumber numberWithInt:homeScore] forKey:@"goals"];
        [homeGhost setValue:[NSNumber numberWithInt:-1] forKey:@"playerId"];
        [homeGhost setValue:homeId forKey:@"teamId"];
        [self.homePlayers addObject:homeGhost];
        
        [self.game setValue:self.homePlayers forKey:@"homePlayers"];

        self.awayPlayers = [[NSMutableArray alloc] init];
        NSNumber* awayId = [self.game valueForKey:@"awayId"];
        NSNumber* awayScoreNumber = [self.game valueForKey:@"awayScore"];
        NSInteger awayScore = [awayScoreNumber integerValue];
        for(NSDictionary* player in rosters) {
            NSNumber* teamId = [player valueForKey:@"teamId"];
            if([teamId integerValue] == [awayId integerValue]) {
                [self.awayPlayers addObject:player];
                NSNumber *goals = [player valueForKey:@"goals"];
                awayScore = awayScore - [goals integerValue];
            }
        }
        
        NSMutableDictionary* awayGhost = [NSMutableDictionary dictionary];
        [awayGhost setValue:@"Ghost" forKey:@"player"];
        [awayGhost setValue:[NSNumber numberWithInt:awayScore] forKey:@"goals"];
        [awayGhost setValue:[NSNumber numberWithInt:-2] forKey:@"playerId"];
        [awayGhost setValue:awayId forKey:@"teamId"];
        [self.awayPlayers addObject:awayGhost];
        
        [self.game setValue:self.awayPlayers forKey:@"awayPlayers"];
    }
    
    [self.tableView reloadData];
}

#pragma mark PlayerDelegate

- (void) addGoal: (NSMutableDictionary*)player
{
    NSNumber *playerId = [player valueForKey:@"playerId"];
    
    for(NSMutableDictionary* homePlayer in self.homePlayers) {
        NSNumber *homePlayerId = [homePlayer valueForKey:@"playerId"];
        
        if([playerId integerValue] == [homePlayerId integerValue]) {
            NSNumber* homeScore = [self.game valueForKey:@"homeScore"];
            NSNumber* newScore = [NSNumber numberWithInt:[homeScore integerValue] + 1];
            [self.game setValue:newScore forKey:@"homeScore"];
        }
    }
    
    for(NSMutableDictionary* awayPlayer in self.awayPlayers) {
        NSNumber *awayPlayerId = [awayPlayer valueForKey:@"playerId"];
        
        if([playerId integerValue] == [awayPlayerId integerValue]) {
            NSNumber* awayScore = [self.game valueForKey:@"awayScore"];
            NSNumber* newScore = [NSNumber numberWithInt:[awayScore integerValue] + 1];
            [self.game setValue:newScore forKey:@"awayScore"];
        }
    }
    
    [self.tableView reloadData];
    
    [self updateGoalForPlayer:[player valueForKey:@"playerId"] game:[self.game valueForKey:@"gameId"] method:@"POST"];
}

- (void) removeGoal: (NSMutableDictionary*)player
{
    NSNumber *playerId = [player valueForKey:@"playerId"];
    
    for(NSMutableDictionary* homePlayer in self.homePlayers) {
        NSNumber *homePlayerId = [homePlayer valueForKey:@"playerId"];
        
        if([playerId integerValue] == [homePlayerId integerValue]) {
            NSNumber* homeScore = [self.game valueForKey:@"homeScore"];
            NSNumber* newScore = [NSNumber numberWithInt:[homeScore integerValue] - 1];
            [self.game setValue:newScore forKey:@"homeScore"];
        }
    }
    
    for(NSMutableDictionary* awayPlayer in self.awayPlayers) {
        NSNumber *awayPlayerId = [awayPlayer valueForKey:@"playerId"];
        
        if([playerId integerValue] == [awayPlayerId integerValue]) {
            NSNumber* awayScore = [self.game valueForKey:@"awayScore"];
            NSNumber* newScore = [NSNumber numberWithInt:[awayScore integerValue] - 1];
            [self.game setValue:newScore forKey:@"awayScore"];
        }
    }
    [self.tableView reloadData];
    
    [self updateGoalForPlayer:[player valueForKey:@"playerId"] game:[self.game valueForKey:@"gameId"] method:@"DELETE"];
}

- (void) played
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.game options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error) {
        NSLog(@"%@", error);
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"http://localhost:8080/service/games/%@/score", [self.game valueForKey:@"gameId"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:jsonData];
    
    [[[NSURLConnection alloc] initWithRequest:request delegate:nil] start];
}

- (void) updateGoalForPlayer:(NSNumber*)playerId game:(NSNumber*)gameId method:(NSString*)method
{
    if([playerId integerValue] > 0) {
        NSError *error;
        NSMutableDictionary* goal = [NSMutableDictionary dictionary];
        [goal setValue:playerId forKey:@"playerId"];
        [goal setValue:gameId forKey:@"gameId"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:goal options:NSJSONWritingPrettyPrinted error:&error];
        
        if(error) {
            NSLog(@"%@", error);
            return;
        }
        
        NSString* url = @"http://localhost:8080/service/goals";
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:method];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:jsonData];
        
        [[[NSURLConnection alloc] initWithRequest:request delegate:nil] start];
    }
}

@end

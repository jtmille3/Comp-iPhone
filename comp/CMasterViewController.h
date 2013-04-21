//
//  CMasterViewController.h
//  comp
//
//  Created by Jeff Miller on 4/20/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDetailViewController;

#import <CoreData/CoreData.h>

@interface CMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

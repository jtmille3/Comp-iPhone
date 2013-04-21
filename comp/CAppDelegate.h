//
//  CAppDelegate.h
//  comp
//
//  Created by Jeff Miller on 4/20/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

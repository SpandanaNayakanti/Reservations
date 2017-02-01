//
//  AppDelegate.h
//  Reservation
//
//  Created by Spandana Nayakanti on 1/25/17.
//  Copyright © 2017 spandana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


+(AppDelegate *) sharedDelegate ;

// custom color method to access over all the classes in project

+ (UIColor*)myColor1;


@end


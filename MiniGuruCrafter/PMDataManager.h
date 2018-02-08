//
//  PMDataManager.h
//  MiniGuruCrafter
//
//  Created by Pavel on 06.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMUser;

@interface PMDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (PMDataManager *) sharedManager;

- (void) generateAndAddRandomData;
- (void) printAllObjects;
- (void) deleteAllObjects;
- (PMUser *) addUserWithName: (NSString *) firstName lastName: (NSString *) lastName andEmail: (NSString *) email;

@end

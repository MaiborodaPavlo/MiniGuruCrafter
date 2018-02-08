//
//  PMUser+CoreDataProperties.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMUser+CoreDataProperties.h"

@implementation PMUser (CoreDataProperties)

+ (NSFetchRequest<PMUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMUser"];
}

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic lernCourses;

@end

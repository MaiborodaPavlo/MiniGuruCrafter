//
//  PMTeacher+CoreDataProperties.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMTeacher+CoreDataProperties.h"

@implementation PMTeacher (CoreDataProperties)

+ (NSFetchRequest<PMTeacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMTeacher"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic courses;

@end

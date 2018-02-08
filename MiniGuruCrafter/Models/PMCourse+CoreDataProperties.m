//
//  PMCourse+CoreDataProperties.m
//  MiniGuruCrafter
//
//  Created by Pavel on 07.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMCourse+CoreDataProperties.h"

@implementation PMCourse (CoreDataProperties)

+ (NSFetchRequest<PMCourse *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMCourse"];
}

@dynamic name;
@dynamic subject;
@dynamic branch;
@dynamic teacher;
@dynamic students;

@end

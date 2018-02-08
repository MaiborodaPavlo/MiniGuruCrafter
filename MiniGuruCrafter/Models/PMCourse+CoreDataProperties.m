//
//  PMCourse+CoreDataProperties.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMCourse+CoreDataProperties.h"

@implementation PMCourse (CoreDataProperties)

+ (NSFetchRequest<PMCourse *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMCourse"];
}

@dynamic branch;
@dynamic name;
@dynamic subject;
@dynamic students;
@dynamic teacher;

@end

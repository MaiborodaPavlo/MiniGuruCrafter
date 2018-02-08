//
//  PMTeacher+CoreDataProperties.h
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMTeacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PMTeacher (CoreDataProperties)

+ (NSFetchRequest<PMTeacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<PMCourse *> *courses;

@end

@interface PMTeacher (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(PMCourse *)value;
- (void)removeCoursesObject:(PMCourse *)value;
- (void)addCourses:(NSSet<PMCourse *> *)values;
- (void)removeCourses:(NSSet<PMCourse *> *)values;

@end

NS_ASSUME_NONNULL_END

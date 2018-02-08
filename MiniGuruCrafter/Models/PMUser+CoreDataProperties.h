//
//  PMUser+CoreDataProperties.h
//  MiniGuruCrafter
//
//  Created by Pavel on 07.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PMUser (CoreDataProperties)

+ (NSFetchRequest<PMUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, retain) NSSet<PMCourse *> *teachCourses;
@property (nullable, nonatomic, retain) NSSet<PMCourse *> *lernCourses;

@end

@interface PMUser (CoreDataGeneratedAccessors)

- (void)addTeachCoursesObject:(PMCourse *)value;
- (void)removeTeachCoursesObject:(PMCourse *)value;
- (void)addTeachCourses:(NSSet<PMCourse *> *)values;
- (void)removeTeachCourses:(NSSet<PMCourse *> *)values;

- (void)addLernCoursesObject:(PMCourse *)value;
- (void)removeLernCoursesObject:(PMCourse *)value;
- (void)addLernCourses:(NSSet<PMCourse *> *)values;
- (void)removeLernCourses:(NSSet<PMCourse *> *)values;

@end

NS_ASSUME_NONNULL_END

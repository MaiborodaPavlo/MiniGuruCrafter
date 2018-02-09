//
//  PMDataManager.m
//  MiniGuruCrafter
//
//  Created by Pavel on 06.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMDataManager.h"
#import "PMUser+CoreDataProperties.h"
#import "PMCourse+CoreDataProperties.h"
#import "PMObject+CoreDataProperties.h"
#import "PMTeacher+CoreDataProperties.h"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

@implementation PMDataManager

+ (PMDataManager *) sharedManager {
    
    static PMDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PMDataManager alloc] init];
    });
    
    return manager;
}

- (PMTeacher *) addRandomTeacher {
    
    PMTeacher *teacher = [NSEntityDescription insertNewObjectForEntityForName: @"PMTeacher" inManagedObjectContext: self.persistentContainer.viewContext];
    
    teacher.firstName = firstNames[arc4random() % 50];
    teacher.lastName = lastNames[arc4random() % 50];
    
    return teacher;
}

- (PMUser *) addRandomUser {
    
    PMUser *user = [NSEntityDescription insertNewObjectForEntityForName: @"PMUser" inManagedObjectContext: self.persistentContainer.viewContext];
    
    user.firstName = firstNames[arc4random() % 50];
    user.lastName = lastNames[arc4random() % 50];
    user.email = [NSString stringWithFormat: @"%@-%@@gmail.com", user.firstName, user.lastName];
    
    return user;
}

- (PMUser *) addUserWithName: (NSString *) firstName lastName: (NSString *) lastName andEmail: (NSString *) email {
    
    PMUser *user = [NSEntityDescription insertNewObjectForEntityForName: @"PMUser" inManagedObjectContext: self.persistentContainer.viewContext];
    
    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    
    return user;
}

- (PMCourse *) addCourseWithName: (NSString *) name subject: (NSString *) subject andBranch: (NSString *) branch {
    
    PMCourse *course = [NSEntityDescription insertNewObjectForEntityForName: @"PMCourse" inManagedObjectContext: self.persistentContainer.viewContext];
    
    course.name = name;
    course.subject = subject;
    course.branch = branch;

    course.teacher = [self addRandomTeacher];
    
    return course;
}

- (NSArray *) allObjects {
    
    NSFetchRequest *request = [PMObject fetchRequest];
    
    NSError *requestError = nil;
    NSArray *resultArray = [self.persistentContainer.viewContext executeFetchRequest: request error: &requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) printArray: (NSArray *) array {
    
    for (id object in array) {
        if ([object isKindOfClass: [PMUser class]]) {
            PMUser *user = (PMUser *) object;
            NSLog(@"USER: %@ %@ COURSES: %li", user.firstName, user.lastName, [user.lernCourses count]);
        } else if ([object isKindOfClass: [PMCourse class]]) {
            PMCourse *course = (PMCourse *) object;
            NSLog(@"COURSE: %@ USERS: %li", course.name, [course.students count]);
        }
    }
}

- (void) printAllObjects {
    
    NSArray *allObjects = [self allObjects];
    
    [self printArray: allObjects];
}

- (void) deleteAllObjects {
    
    NSArray *allObjects = [self allObjects];
    
    for (id object in allObjects) {
        [self.persistentContainer.viewContext deleteObject: object];
    }
    
    [self saveContext];
}

- (NSArray *) getTeachersWithoutCourses {
    
    NSFetchRequest *fetchRequest = [PMTeacher fetchRequest];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"courses.@count == %d", 0];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"firstName" ascending: YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"lastName" ascending: YES];
    
    [fetchRequest setSortDescriptors: @[firstNameDescriptor, lastNameDescriptor]];
    
    NSError *error = nil;
    
    return [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
}

- (void) generateAndAddRandomData {
    
    NSArray *courses = @[[self addCourseWithName: @"iOS development" subject:@"Objective-c" andBranch: @"mobile programming"], [self addCourseWithName: @"Android development" subject: @"Java" andBranch: @"mobile programming"], [self addCourseWithName: @"Backend. PHP development" subject: @"PHP" andBranch: @"web development"], [self addCourseWithName: @"Frontend. JavaScript level" subject: @"JS" andBranch: @"web development"], [self addCourseWithName: @"Frontend. HTML level" subject: @"HTML" andBranch: @"web development"]];
    
    for (int i = 0; i < 100; i++) {
        
        PMUser *user = [self addRandomUser];

        NSInteger number = arc4random() % 5 + 1;
        
        while ([user.lernCourses count] < number) {
            
            PMCourse *course = [courses objectAtIndex: arc4random() % 5];
            
            if (![user.lernCourses containsObject: course]) {
                [user addLernCoursesObject: course];
            }
        }
    }
    
    [self saveContext];
    
    // [self printAllObjects];
    
    //NSFetchRequest *request = [PMStudent fetchRequest];
    //NSFetchRequest *request = [PMCar fetchRequest];
    //NSFetchRequest *request = [PMUniversity fetchRequest];
    //NSFetchRequest *request = [PMCourse fetchRequest];
    
    
    //[request setFetchBatchSize: 20];
    //[request setFetchOffset: 10];
    //[request setFetchLimit: 35];
    
    //[request setRelationshipKeyPathsForPrefetching: @[@"courses"]];
    //[request setRelationshipKeyPathsForPrefetching: @[@"students"]];
    /*
     NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"firstName" ascending: YES];
     NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"lastName" ascending: YES];
     
     [request setSortDescriptors: @[firstNameDescriptor, lastNameDescriptor]];
     */
    
    //NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    //[request setSortDescriptors: @[nameDescriptor]];
    
    //NSArray *validNames = @[@"Arvilla", @"Floyd", @"Vernell"];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"score > %f AND score < %f AND courses.@count >= %d AND firstName IN %@", 3.0f, 4.f, 3, validNames];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"students.@avg.score > %f", 3.5f];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SUBQUERY(students, $student, $student.car.model == %@).@count >= %i", @"BMW", 7];
    
    //[request setPredicate: predicate];
    
    //NSFetchRequest *request = [[self.persistentContainer.managedObjectModel fetchRequestTemplateForName: @"FetchStudents"] copy];
    /*
     [request setRelationshipKeyPathsForPrefetching: @[@"students"]];
     
     NSArray *resultArray = [self.persistentContainer.viewContext executeFetchRequest: request error: nil];
     
     for (PMCourse *course in resultArray) {
     
     NSLog(@"COURSE: %@", course.name);
     NSLog(@"BEST STUDENTS: ");
     [self printArray: course.bestStudents];
     NSLog(@"BUZY STUDENTS: ");
     [self printArray: course.studentsWithManyCourses];
     }
     */
    
    //resultArray = [resultArray subarrayWithRange: NSMakeRange(0, 50)];
    
    //[self printArray: resultArray];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *) persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MiniGuruCrafter"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void) saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end

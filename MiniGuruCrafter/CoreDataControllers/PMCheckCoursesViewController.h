//
//  PMCheckCoursesViewController.h
//  MiniGuruCrafter
//
//  Created by Pavel on 09.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMCoreDataTableViewController.h"

@class PMUser, PMTeacher;

@interface PMCheckCoursesViewController : PMCoreDataTableViewController

@property (strong, nonatomic) PMUser *user;
@property (strong, nonatomic) PMTeacher *teacher;

@end

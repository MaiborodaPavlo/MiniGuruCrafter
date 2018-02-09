//
//  PMCheckTeachersViewController.h
//  MiniGuruCrafter
//
//  Created by Pavel on 09.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMCoreDataTableViewController.h"

@class PMCourse;

@interface PMCheckTeachersViewController : PMCoreDataTableViewController

@property (strong, nonatomic) PMCourse *course;

@end

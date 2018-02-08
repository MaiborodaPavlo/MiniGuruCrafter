//
//  PMCheckUsersViewController.h
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMCoreDataTableViewController.h"

@class PMCourse;

@interface PMCheckUsersViewController : PMCoreDataTableViewController

@property (strong, nonatomic) PMCourse *course;

@end

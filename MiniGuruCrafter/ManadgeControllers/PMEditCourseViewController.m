//
//  PMEditCourseViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMEditCourseViewController.h"
#import "PMCourse+CoreDataProperties.h"
#import "PMEditCourseTableViewCell.h"
#import "PMTeacher+CoreDataProperties.h"
#import "PMDataManager.h"
#import "PMEditUserViewController.h"
#import "PMCheckUsersViewController.h"
#import "PMCheckTeachersViewController.h"

@interface PMEditCourseViewController ()

@property (assign, nonatomic) BOOL isNew;

@end

typedef enum {
    PMSectionTypeCourseInfo,
    PMSectionTypeTeacher,
    PMSectionTypeStudents
} PMSectionType;

typedef enum {
    PMCourseDataTypeName,
    PMCourseDataTypeSubject,
    PMCourseDataTypeBranch,
    PMCourseDataTypeTeacher
} PMCourseDataType;

@implementation PMEditCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNew = self.course == nil ? YES : NO;
    
    self.navigationItem.title = self.isNew ? @"Add new course" : @"Edit course";
    
    if (self.isNew) {
        self.course = [NSEntityDescription insertNewObjectForEntityForName: @"PMCourse" inManagedObjectContext: [[[PMDataManager sharedManager] persistentContainer] viewContext]];
        
        [self.navigationItem setHidesBackButton: YES];
        
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleDone target: self action: @selector(actionCancel:)];
        
        self.navigationItem.leftBarButtonItem = cancelBarButton;
    }
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone:)];
    
    self.navigationItem.rightBarButtonItem = doneBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) dismissMe {
    
    if (self.isNew) {
        [self dismissViewControllerAnimated: YES completion: nil];
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void) actionCancel: (UIBarButtonItem *) sender {
    
    [[[[PMDataManager sharedManager] persistentContainer] viewContext] deleteObject: self.course];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissMe];
    });
    
}

- (void) actionDone: (UIBarButtonItem *) sender {
    
    for (int i = 0; i < 3; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: PMSectionTypeCourseInfo];
        
        PMEditCourseTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        
        if ([cell.nameLabel.text isEqualToString: @"Name"]) {
            self.course.name = cell.nameField.text;
        } else if([cell.nameLabel.text isEqualToString: @"Subject"]) {
            self.course.subject = cell.nameField.text;
        } else if ([cell.nameLabel.text isEqualToString: @"Branch"]) {
            self.course.branch = cell.nameField.text;
        }
    }
    
    NSError *error = nil;
    
    [self.course.managedObjectContext save: &error];
    
    if (error) {
        NSLog(@"ERRROR: %@", [error localizedDescription]);
    }
    
    [self dismissMe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == PMSectionTypeCourseInfo) {
        return @"Course info";
    } else if (section == PMSectionTypeTeacher) {
        return @"Teacher";
    } else {
        return @"Students";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == PMSectionTypeCourseInfo) {
        return 3;
    } else if (section == PMSectionTypeTeacher) {
        return 1;
    } else {
        return [self.course.students count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == PMSectionTypeCourseInfo) {
        static NSString *identifier = @"EditCell";
        
        PMEditCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        switch (indexPath.row) {
            case PMCourseDataTypeName:
                cell.nameLabel.text = @"Name";
                cell.nameField.text = self.course.name;
                break;
                
            case PMCourseDataTypeSubject:
                cell.nameLabel.text = @"Subject";
                cell.nameField.text = self.course.subject;
                break;
                
            case PMCourseDataTypeBranch:
                cell.nameLabel.text = @"Branch";
                cell.nameField.text = self.course.branch;
                break;
            default: NSLog(@"AAAA");
                break;
        }
        
        return cell;
        
    } else if (indexPath.section == PMSectionTypeTeacher) {
        
        static NSString *identifier = @"TeacherCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
        }
        
        if (self.course.teacher == nil) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"Add Lecturer";
        } else {
            cell.textLabel.textAlignment = NSTextAlignmentNatural;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstName, self.course.teacher.lastName];
        }
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"StudentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"Add Student";
        } else {
            NSArray *tempArray = [self.course.students allObjects];
            
            cell.textLabel.textAlignment = NSTextAlignmentNatural;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[tempArray objectAtIndex: indexPath.row - 1] firstName], [[tempArray objectAtIndex: indexPath.row - 1] lastName]];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == PMSectionTypeStudents) {
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray: [self.course.students allObjects]];
            PMUser *user = [tempArray objectAtIndex: indexPath.row - 1];
            
            [tempArray removeObject: user];
            [self.course setStudents: [NSSet setWithArray: tempArray]];
            
            [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
            
        } else if (indexPath.section == PMSectionTypeTeacher) {
            
            [self.course setTeacher: nil];
            [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == PMSectionTypeCourseInfo) {
        return NO;
    } else if (indexPath.section == PMSectionTypeTeacher && self.course.teacher == nil) {
        return NO;
    } else if (indexPath.section == PMSectionTypeStudents && indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == PMSectionTypeStudents && indexPath.row != 0) {

        PMUser *user = [[self.course.students allObjects] objectAtIndex: indexPath.row - 1];
        
        PMEditUserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditUserViewController"];
        vc.user = user;
        
        [self.navigationController pushViewController: vc animated: YES];
        
    } else if (indexPath.section == PMSectionTypeStudents) {
        
        PMCheckUsersViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMCheckUsersViewController"];
        vc.course = self.course;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
        
        [self presentViewController: nav animated: YES completion: nil];
    }
    
    if (indexPath.section == PMSectionTypeTeacher) {
        
        PMCheckTeachersViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMCheckTeachersViewController"];
        vc.course = self.course;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
        
        [self presentViewController: nav animated: YES completion: nil];
    }
}

@end

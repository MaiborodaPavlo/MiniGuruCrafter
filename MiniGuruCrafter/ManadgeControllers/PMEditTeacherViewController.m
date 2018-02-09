//
//  PMEditTeacherViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 09.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMEditTeacherViewController.h"
#import "PMTeacher+CoreDataProperties.h"
#import "PMEditTeacherTableViewCell.h"
#import "PMCourse+CoreDataProperties.h"
#import "PMDataManager.h"
#import "PMCheckCoursesViewController.h"

@interface PMEditTeacherViewController ()

@property (assign, nonatomic) BOOL isNew;

@end

@implementation PMEditTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNew = self.teacher == nil ? YES : NO;
    
    if (self.isNew) {
        self.teacher = [NSEntityDescription insertNewObjectForEntityForName: @"PMTeacher" inManagedObjectContext: [[[PMDataManager sharedManager] persistentContainer] viewContext]];
        
        [self.navigationItem setHidesBackButton: YES];
        
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleDone target: self action: @selector(actionCancel:)];
        
        self.navigationItem.leftBarButtonItem = cancelBarButton;
    }
    
    self.navigationItem.title = self.isNew ? @"Add new teacher" : @"Edit Teacher";
    
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
    
    [[[[PMDataManager sharedManager] persistentContainer] viewContext] deleteObject: self.teacher];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissMe];
    });
}

- (void) actionDone: (UIBarButtonItem *) sender {
    
    for (int i = 0; i < 2; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        
        PMEditTeacherTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        
        if ([cell.nameLabel.text isEqualToString: @"First name"]) {
            self.teacher.firstName = cell.nameField.text;
        } else if([cell.nameLabel.text isEqualToString: @"Last name"]) {
            self.teacher.lastName = cell.nameField.text;
        }
    }
    
    [[PMDataManager sharedManager] saveContext];
    
    [self dismissMe];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

        return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Teacher info";
    } else {
        return @"Courses";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    } else {
        return [self.teacher.courses count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"EditCell";
        
        PMEditTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        switch (indexPath.row) {
            case 0:
                cell.nameLabel.text = @"First name";
                cell.nameField.text = self.teacher.firstName;
                break;
                
            case 1:
                cell.nameLabel.text = @"Last name";
                cell.nameField.text = self.teacher.lastName;
                break;
                
            default: NSLog(@"AAAA");
                break;
        }
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"CourseCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"Add Course";
        } else {
            cell.textLabel.textAlignment = NSTextAlignmentNatural;
            NSArray *tempArray = [self.teacher.courses allObjects];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex: indexPath.row - 1] name]];
        }
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 1) {
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray: [self.teacher.courses allObjects]];
            PMCourse *course = [tempArray objectAtIndex: indexPath.row - 1];
            
            [tempArray removeObject: course];
            [self.teacher setCourses: [NSSet setWithArray: tempArray]];
            
            [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        PMCheckCoursesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMCheckCoursesViewController"];
        vc.teacher = self.teacher;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
        
        [self presentViewController: nav animated: YES completion: nil];
    }
}


@end

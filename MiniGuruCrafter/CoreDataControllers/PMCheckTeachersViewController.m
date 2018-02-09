//
//  PMCheckTeachersViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 09.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMCheckTeachersViewController.h"
#import "PMTeacher+CoreDataProperties.h"
#import "PMCourse+CoreDataProperties.h"

@interface PMCheckTeachersViewController ()

@end

@implementation PMCheckTeachersViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select teacher";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionDone: (UIBarButtonItem *) sender {
    
    [self.managedObjectContext save: nil];
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
}

#pragma mark - UITableViewDataSourse

- (void)configureCell:(UITableViewCell *)cell atIndexPath: (NSIndexPath *) indexPath {
    
    PMTeacher *teacher = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", teacher.firstName, teacher.lastName];
    
    if ([self.course.teacher isEqual: teacher]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    PMTeacher *teacher = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject: self.course.teacher];
        [[tableView cellForRowAtIndexPath: indexPath] setAccessoryType: UITableViewCellAccessoryNone];
        
        self.course.teacher = teacher;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [PMTeacher fetchRequest];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"firstName" ascending: YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"lastName" ascending: YES];
    
    [fetchRequest setSortDescriptors: @[firstNameDescriptor, lastNameDescriptor]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest managedObjectContext: self.managedObjectContext sectionNameKeyPath: nil cacheName: nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}


@end

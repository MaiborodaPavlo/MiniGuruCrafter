//
//  PMCheckUsersViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMCheckUsersViewController.h"
#import "PMUser+CoreDataProperties.h"
#import "PMCourse+CoreDataProperties.h"

@interface PMCheckUsersViewController ()

@end

@implementation PMCheckUsersViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select users";
    
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
    
    PMUser *user = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", user.firstName, user.lastName];

    if ([self.course.students containsObject: user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    PMUser *user = [self.fetchedResultsController objectAtIndexPath: indexPath];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.course addStudentsObject: user];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.course removeStudentsObject: user];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [PMUser fetchRequest];
    
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

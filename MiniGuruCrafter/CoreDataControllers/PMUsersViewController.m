//
//  ViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 06.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMUsersViewController.h"
#import "PMDataManager.h"
#import "PMUser+CoreDataProperties.h"
#import "PMEditUserViewController.h"

@interface PMUsersViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PMUsersViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Users";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction) actionAddUser: (UIBarButtonItem *) sender {
    
    PMEditUserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditUserViewController"];
    vc.user = nil;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nav animated: YES completion: nil];
}

#pragma mark - UITableViewDataSourse

- (void)configureCell:(UITableViewCell *)cell atIndexPath: (NSIndexPath *) indexPath {
    
    PMUser *user = [self.fetchedResultsController objectAtIndexPath: indexPath];

    cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", user.firstName, user.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%lu", [user.lernCourses count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PMUser *user = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    PMEditUserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditUserViewController"];
    vc.user = user;
    
    [self.navigationController pushViewController: vc animated: YES];
    
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
    
    [fetchRequest setRelationshipKeyPathsForPrefetching: @[@"lernCourses"]];
    
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

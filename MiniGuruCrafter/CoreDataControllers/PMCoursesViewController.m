//
//  PMCoursesViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMCoursesViewController.h"
#import "PMCourse+CoreDataProperties.h"
#import "PMEditCourseViewController.h"

@interface PMCoursesViewController ()

@end

@implementation PMCoursesViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Courses";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionAddCourse:(UIBarButtonItem *)sender {
    
    PMEditCourseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditCourseViewController"];
    vc.course = nil;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nav animated: YES completion: nil];
}

#pragma mark - UITableViewDataSourse

- (void)configureCell:(UITableViewCell *)cell atIndexPath: (NSIndexPath *) indexPath {
    
    PMCourse *course = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@", course.name];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%lu", [course.students count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    PMCourse *course = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    PMEditCourseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditCourseViewController"];
    vc.course = course;
    
    [self.navigationController pushViewController: vc animated: YES];

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [PMCourse fetchRequest];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    
    [fetchRequest setSortDescriptors: @[nameDescriptor]];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching: @[@"students"]];
    
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

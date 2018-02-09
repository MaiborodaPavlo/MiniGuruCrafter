//
//  PMTeachersViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 09.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMTeachersViewController.h"
#import "PMTeacher+CoreDataProperties.h"
#import "PMEditTeacherViewController.h"
#import "PMCourse+CoreDataProperties.h"
#import "PMDataManager.h"

@interface PMTeachersViewController ()

@property (strong, nonatomic) NSArray *teachersWithoutCourses;

@end

@implementation PMTeachersViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Teachers";
    
    self.teachersWithoutCourses = [[PMDataManager sharedManager] getTeachersWithoutCourses];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    self.teachersWithoutCourses = [[PMDataManager sharedManager] getTeachersWithoutCourses];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionAddTeacher:(UIBarButtonItem *)sender {
    
    PMEditTeacherViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditTeacherViewController"];
    vc.teacher = nil;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nav animated: YES completion: nil];
}

#pragma mark - UITableViewDataSourse

- (void)configureCell:(UITableViewCell *)cell atIndexPath: (NSIndexPath *) indexPath {
    
    if ([[self.fetchedResultsController sections] count] - 1 >= indexPath.section) {
        
        PMCourse *course = [self.fetchedResultsController objectAtIndexPath: indexPath];
        PMTeacher *teacher = course.teacher;
        
        cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", teacher.firstName, teacher.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%lu", [teacher.courses count]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else {
        
        PMTeacher *teacher = [self.teachersWithoutCourses objectAtIndex: indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", teacher.firstName, teacher.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%lu", [teacher.courses count]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if ([[self.fetchedResultsController sections] count] - 1 >= section ) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    } else {
        return [self.teachersWithoutCourses count];
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([[self.fetchedResultsController sections] count] - 1 >= section) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo name];
        
    } else {
        return @"Other teachers";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PMTeacher *teacher = nil;
    
    if ([[self.fetchedResultsController sections] count] - 1 >= indexPath.section) {
        PMCourse *course = [self.fetchedResultsController objectAtIndexPath: indexPath];
        teacher = course.teacher;
    } else {
        teacher = [self.teachersWithoutCourses objectAtIndex: indexPath.row];
    }
    
    PMEditTeacherViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"PMEditTeacherViewController"];
    vc.teacher = teacher;
    
    [self.navigationController pushViewController: vc animated: YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if ([[self.fetchedResultsController sections] count] - 1 >= indexPath.section) {
            
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        } else {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray: self.teachersWithoutCourses];
            PMTeacher *teacher = [tempArray objectAtIndex: indexPath.row];
            [self.managedObjectContext deleteObject: teacher];
            [tempArray removeObject: teacher];
            
            self.teachersWithoutCourses = tempArray;
            
            [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }
        
        [self.managedObjectContext save: nil];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [PMCourse fetchRequest];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    
    [fetchRequest setSortDescriptors: @[nameDescriptor]];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching: @[@"teacher"]];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest managedObjectContext: self.managedObjectContext sectionNameKeyPath: @"name" cacheName: nil];
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

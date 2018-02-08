//
//  PMCoreDataTableViewController.h
//  MiniGuruCrafter
//
//  Created by Pavel on 07.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PMCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath;

@end

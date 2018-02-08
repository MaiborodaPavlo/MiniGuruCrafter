//
//  PMEditUserViewController.h
//  MiniGuruCrafter
//
//  Created by Pavel on 06.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class PMUser;

@interface PMEditUserViewController : UITableViewController

@property (strong, nonatomic) PMUser *user;

@end



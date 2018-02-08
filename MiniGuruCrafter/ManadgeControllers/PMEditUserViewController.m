//
//  PMEditUserViewController.m
//  MiniGuruCrafter
//
//  Created by Pavel on 06.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMEditUserViewController.h"
#import "PMUser+CoreDataProperties.h"
#import "PMEditUserTableViewCell.h"
#import "PMDataManager.h"
#import "UIView+PMTableViewCell.h"

@interface PMEditUserViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (assign, nonatomic) BOOL isNewUser;


@end

typedef enum {
    PMUserDataTypeFirstName,
    PMUserDataTypeLastName,
    PMUserDataTypeEmail
} PMUserDataType;

@implementation PMEditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNewUser = self.user == nil ? YES : NO;
    
    if (self.isNewUser) {
        self.user = [NSEntityDescription insertNewObjectForEntityForName: @"PMUser" inManagedObjectContext: [[[PMDataManager sharedManager] persistentContainer] viewContext]];
        
        [self.navigationItem setHidesBackButton: YES];
        
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleDone target: self action: @selector(actionCancel:)];
        
        self.navigationItem.leftBarButtonItem = cancelBarButton;
    }
    
    self.navigationItem.title = self.isNewUser ? @"Add new user" : @"Edit user";
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone:)];
    
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Actions

- (void) dismissMe {
    
    if (self.isNewUser) {
        [self dismissViewControllerAnimated: YES completion: nil];
    } else {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void) actionCancel: (UIBarButtonItem *) sender {
    
    [[[[PMDataManager sharedManager] persistentContainer] viewContext] deleteObject: self.user];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissMe];
    });
}

- (void) actionDone: (UIBarButtonItem *) sender {
    
    for (int i = 0; i < 3; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        
        PMEditUserTableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        
        if ([cell.nameLabel.text isEqualToString: @"First name"]) {
            self.user.firstName = cell.nameField.text;
        } else if([cell.nameLabel.text isEqualToString: @"Last name"]) {
            self.user.lastName = cell.nameField.text;
        } else if ([cell.nameLabel.text isEqualToString: @"Email"]) {
            self.user.email = cell.nameField.text;
        }
    }
    
    NSError *error = nil;
    
    [self.user.managedObjectContext save: &error];
    
    if (error) {
        NSLog(@"ERRROR: %@", [error localizedDescription]);
    }
    
    [self dismissMe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"User info";
    } else {
        return @"Courses";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    } else {
        return [self.user.lernCourses count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"EditCell";
        
        PMEditUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        switch (indexPath.row) {
            case PMUserDataTypeFirstName:
                cell.nameLabel.text = @"First name";
                cell.nameField.text = self.user.firstName;
                break;
                
            case PMUserDataTypeLastName:
                cell.nameLabel.text = @"Last name";
                cell.nameField.text = self.user.lastName;
                break;
                
            case PMUserDataTypeEmail:
                cell.nameLabel.text = @"Email";
                cell.nameField.text = self.user.email;
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
        
        NSArray *tempArray = [self.user.lernCourses allObjects];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex: indexPath.row] name]];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    PMEditUserTableViewCell *cell = (PMEditUserTableViewCell *)[textField superCell];
    
    if ([cell.nameLabel.text isEqualToString: @"Email"]) {
        textField.returnKeyType = UIReturnKeyDone;
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    PMEditUserTableViewCell *cell = (PMEditUserTableViewCell *)[textField superCell];
    
    if ([cell.nameLabel.text isEqualToString: @"Email"]) {
    
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@0123456789!#$%&'*+-/=?^_`{|}~"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([textField.text rangeOfString:@"@"].location == NSNotFound && [string rangeOfString:@"@"].location != NSNotFound) {
            return [string isEqualToString:filtered];
            
        } else if ([string rangeOfString:@"@"].location == NSNotFound) {
            
            return [string isEqualToString:filtered];
        } else {
            return NO;
        }
    } else {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString: filtered];
    }
    
    return YES;
    
}


@end

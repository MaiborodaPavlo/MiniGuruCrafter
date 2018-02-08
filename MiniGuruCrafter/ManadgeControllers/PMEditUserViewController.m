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
    }
    
    self.navigationItem.title = @"Edit user";
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone:)];
    
    self.navigationItem.rightBarButtonItem = doneBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Actions

- (void) actionDone: (UIBarButtonItem *) sender {
    
    for (PMEditUserTableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.nameLabel.text isEqualToString: @"First name"]) {
            self.user.firstName = cell.nameField.text;
        } else if([cell.nameLabel.text isEqualToString: @"Last name"]) {
            self.user.lastName = cell.nameField.text;
        } else {
            self.user.email = cell.nameField.text;
        }
    }
    
    NSError *error = nil;
    
    [self.user.managedObjectContext save: &error];
    
    if (error) {
        NSLog(@"ERRROR: %@", [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated: YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

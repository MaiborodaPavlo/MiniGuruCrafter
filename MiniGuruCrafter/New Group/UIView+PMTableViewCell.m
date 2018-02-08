//
//  UIView+PMTableViewCell.m
//  MiniGuruCrafter
//
//  Created by Pavel on 08.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "UIView+PMTableViewCell.h"

@implementation UIView (PMTableViewCell)

- (UITableViewCell *) superCell {
    
    if (!self.superview) {
        return nil;
    }
    
    if ([self isKindOfClass: [UITableViewCell class]]) {
        return (UITableViewCell *)self;
    }
    
    return [self.superview superCell];
    
}

@end

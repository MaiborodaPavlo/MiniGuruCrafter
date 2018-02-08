//
//  PMObject+CoreDataProperties.m
//  MiniGuruCrafter
//
//  Created by Pavel on 07.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMObject+CoreDataProperties.h"

@implementation PMObject (CoreDataProperties)

+ (NSFetchRequest<PMObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMObject"];
}


@end

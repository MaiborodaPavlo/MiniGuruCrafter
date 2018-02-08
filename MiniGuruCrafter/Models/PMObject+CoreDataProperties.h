//
//  PMObject+CoreDataProperties.h
//  MiniGuruCrafter
//
//  Created by Pavel on 07.02.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//
//

#import "PMObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PMObject (CoreDataProperties)

+ (NSFetchRequest<PMObject *> *)fetchRequest;


@end

NS_ASSUME_NONNULL_END

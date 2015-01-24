//
//  ProfileController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/20/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileController : NSObject 

- (void)requestProfileItemsWithCompletion: (void (^)(NSDictionary *profileItems, NSError *error))callBack;

@end

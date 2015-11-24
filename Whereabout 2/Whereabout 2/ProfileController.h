//
//  ProfileController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/20/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileController : NSObject 

@property (nonatomic, retain) NSMutableArray *itemCollection;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSMutableDictionary *indexDict;

- (void)getProfilePropertiesWithCompletion: (void (^)(NSDictionary *profileProperties, NSError *error))callBack;

- (void)deletePhotoFromDBWithPhotoID:(NSString *)photoId andCompletion:(void(^)(NSError *completionError))completionHandler;

- (void)requestProfileItemsFromUser:(NSString *) Id AndIsCurrentUser:(BOOL) isCurrentUser WithCompletion: (void (^)(NSMutableArray *Items, NSError *error))callBack;


@end

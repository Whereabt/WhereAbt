//
//  StreamLogic.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/12/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationController.h"

@interface StreamController : NSObject

@property (nonatomic, retain) NSMutableArray *itemCollection;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSMutableDictionary *indexDict;
@property (nonatomic, retain) NSString *sortType;

- (void)imageFromURLString:(NSString *)urlString atIndex:(NSInteger)index OfArray:(NSArray*)jsonArray isThumbnail:(BOOL) isThumbnail;

- (void)getFeedWithType:(NSString *)streamType andCompletion:(void (^)(NSMutableArray *items, NSError *error))callBack;
- (void)reportPhotoWithUserID: (NSString *)userId andPhotoID: (NSString *)photoId andReason: (NSString *)reasonID withCompletion:(void (^)(NSError *error))completionHandler;
- (void)getFeedFromAzureCloudFileWithRadius:(float)radius andCompletion:(void (^)(NSMutableArray *items, NSError *error))callBack;

@end

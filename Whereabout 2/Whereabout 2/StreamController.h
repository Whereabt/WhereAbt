//
//  StreamLogic.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/12/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface StreamController : NSObject

@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSMutableDictionary *indexDict;

- (void)imageFromURLString:(NSString *)urlString atIndex:(NSInteger)index OfArray:(NSArray*)jsonArray;
- (void)getFeedWithCompletion:(void (^)(NSMutableArray *items, NSError *error))callBack;

@end

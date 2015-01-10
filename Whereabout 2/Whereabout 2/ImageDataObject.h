//
//  ImageDataObject.h
//  Whereabout 2
//
//  Created by Nicolas on 1/3/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataObject : NSObject

//method declaration
- (id)initWithJSONData: (NSDictionary*)data;

//property declarations for query string parameters
@property (strong) id userID;
@property (assign) id latitude;
@property (assign) id longitude;
@property (strong) id photoURL;

@end

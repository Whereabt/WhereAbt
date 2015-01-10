//
//  ImageDataObject.m
//  Whereabout 2
//
//  Created by Nicolas on 1/3/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ImageDataObject.h"
#import "StreamViewController.h"

//creating properties for query string parameters
@implementation ImageDataObject

@synthesize userID;
@synthesize latitude;
@synthesize longitude;
@synthesize photoURL;


//implementing method that moves json dictionary data into the class's properties
- (id)initWithJSONData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        self.userID = [[data objectForKey:@"UserID"]stringValue];
        self.latitude = [data objectForKey:@"Latitude"];
        self.longitude = [data objectForKey:@"Longitude"];
        self.photoURL = [data objectForKey:@"PhotoURL"];
    }
    return self;
}

//url request preparation


@end

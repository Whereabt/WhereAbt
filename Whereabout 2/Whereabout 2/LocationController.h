//
//  LocationController.h
//  Whereabout 2
//
//  Created by Lucas Isaza on 1/8/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationController : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

+ (instancetype)sharedController;
- (void)updateUserLocation;
- (CLLocation*)getCurrentLocation;

@end

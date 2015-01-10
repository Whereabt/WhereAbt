//
//  LocationController.m
//  Whereabout 2
//
//  Created by Lucas Isaza on 1/8/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

+ (instancetype)sharedController {
    static LocationController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
        //[sharedController updateUserLocation];
    });
    return sharedController;
}

- (instancetype)init{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;

        _currentLocation = [[CLLocation alloc] initWithLatitude:45 longitude:12];
        //_currentLocation = [[CLLocation alloc]initWithLatitude:41.694 longitude:-83.6];
    }
  return self;
}



- (void)updateUserLocation{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //check authorization status
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager startUpdatingLocation];
    }
}

- (CLLocation*)getCurrentLocation{
    [self updateUserLocation];
    if (_currentLocation != nil) {
        NSLog(@"%@", _currentLocation);
    }
    return _currentLocation;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    /*UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error Occurred" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
     */
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _currentLocation = [locations lastObject];
    NSLog(@"Your Latitude: %f Your Longitude: %f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.latitude);
    [self.locationManager stopUpdatingLocation];
}

@end

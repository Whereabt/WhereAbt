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
        [sharedController updateUserLocation];
    });
    return sharedController;
}

- (instancetype)init{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
  return self;
}

- (void)getNameFromLocation: (CLLocation *)locationParam isNear: (BOOL)isNear AndCompletion:(void (^)(NSString *locationName))callBack {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationParam
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                        }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       NSLog(@"placemark.country %@",placemark.country);
                       NSLog(@"placemark.postalCode %@",placemark.postalCode);
                       NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                       NSLog(@"placemark.locality %@",placemark.locality);
                       NSLog(@"placemark.subLocality %@",placemark.subLocality);
                       NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
                       NSString *locationString;
                       
                       if (!isNear) {
                           if (placemark.subLocality) {
                               locationString = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.subLocality, placemark.locality, placemark.administrativeArea, placemark.ISOcountryCode];
                           }
                           else {
                               if (placemark.locality) {
                                   locationString = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.administrativeArea, placemark.ISOcountryCode];
                               }
                               else {
                                   locationString = [NSString stringWithFormat:@"%@, %@", placemark.administrativeArea, placemark.ISOcountryCode];
                               }

                        }

                    }
                       else {
                           if (placemark.subLocality) {
                               locationString = [NSString stringWithFormat:@"%@", placemark.subLocality];
                           }
                           else {
                               if (placemark.locality) {
                                   locationString = [NSString stringWithFormat:@"%@", placemark.locality];
                               }
                               else {
                                   locationString = [NSString stringWithFormat:@"%@", placemark.administrativeArea];
                               }
                               
                           }

                       }
                       callBack(locationString);
                   }];
}


- (void)updateUserLocation{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //resumes location update when device moves at least 100 meters horizontally
    self.locationManager.distanceFilter = 100;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //check authorization status
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager startUpdatingLocation];
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _currentLocation = [locations lastObject];
    NSLog(@"Your Latitude: %f Your Longitude: %f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
}

@end

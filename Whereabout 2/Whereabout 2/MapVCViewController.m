//
//  MapVCViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 8/22/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "MapVCViewController.h"
#import "MapAnnotation.h"
#import "LocationController.h"

#define METERS_PER_MILE 1609.344

@interface MapVCViewController ()

@end

@implementation MapVCViewController

CLLocation *Location;
NSDictionary *imageDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (!Location) {
        UIAlertView *noMappingAlert = [[UIAlertView alloc] initWithTitle:@"Location Not Available" message:@"The user denied mapping for this photo." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noMappingAlert show];

    }
    
    else {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = Location.coordinate.latitude;
    zoomLocation.longitude= Location.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    __block NSString *place;
    
    LocationController *locationCont = [[LocationController alloc] init];
    [locationCont getNameFromLocation:Location isNear:YES AndCompletion:^(NSString *locationName) {
        place = [[NSString alloc] initWithString:locationName];
    }];
    
    [_mapView setRegion:viewRegion animated:YES];
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:imageDict[@"Name"] address:place coordinate:Location.coordinate] ;
    [_mapView addAnnotation:annotation];
        
    }
}

- (void)setUpMapViewWithDictionary:(NSDictionary *)photoDict {
    Location = [[CLLocation alloc] init];
    if ([photoDict[@"Mapping"]  isEqual: @"TRUE"]) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[photoDict[@"Latitude"] doubleValue] longitude:[photoDict[@"Longitude"] doubleValue]];
        Location = location;
    }
    
    else {
        Location = nil;
    }
    imageDict = [[NSDictionary alloc] init];
    imageDict = photoDict;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

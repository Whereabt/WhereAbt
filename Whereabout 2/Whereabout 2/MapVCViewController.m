//
//  MapVCViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 8/22/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "MapVCViewController.h"
#import "MapAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface MapVCViewController ()

@end

@implementation MapVCViewController

CLLocation *Location;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = Location.coordinate.latitude;
    zoomLocation.longitude= Location.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:@"Photo" address:[NSString stringWithFormat:@"Address"] coordinate:Location.coordinate] ;
    [_mapView addAnnotation:annotation];
}

- (void)setUpMapViewWithLocation: (CLLocation *)imageLocation {
    Location = [[CLLocation alloc] init];
    Location = imageLocation;
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

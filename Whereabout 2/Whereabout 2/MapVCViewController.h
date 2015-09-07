//
//  MapVCViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 8/22/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapVCViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (void)setUpMapViewWithDictionary:(NSDictionary *)photoDict;

@end

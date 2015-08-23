//
//  MapAnnotation.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 8/22/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

- (MKMapItem*)mapItem;

@end

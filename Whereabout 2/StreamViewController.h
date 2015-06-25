//
//  StreamViewController.h
//  Whereabout 2
//
//  Created by Nicolas on 1/1/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StreamViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tableActivityIndicator;

- (IBAction)refreshButtonCall:(id)sender;

@end

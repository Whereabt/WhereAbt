//
//  StreamViewController.h
//  Whereabout 2
//
//  Created by Nicolas on 1/1/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol StreamDelegate <NSObject>
- (void)recievedLocalStreamJSON:(NSData *)objectNotation;
- (void)gettingLocalStreamFailedWithError:(NSError *)error;

@end

@interface StreamViewController : UITableViewController <CLLocationManagerDelegate>


//property declarations for query string parameters
@property (strong) NSString* userID;
@property (assign) id latitude;
@property (assign) id longitude;
@property (strong) id photoURL;
@property (strong) id milesAway;
@property (weak,nonatomic) id<StreamDelegate> delegate;

- (void)imageFromURLString:(NSString *)urlString atIndex: (NSInteger)index;
- (IBAction)pinSelected:(id)sender;
- (void)requestFeedWithClientLocation:(CLLocation*)location;




@end
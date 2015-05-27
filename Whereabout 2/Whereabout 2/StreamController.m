 //
//  StreamLogic.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/12/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamController.h"
#import "LocationController.h"
#import "StreamViewController.h"

/*
static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";
*/
 
@implementation StreamController


- (void)getFeedWithRadius:(float)radius andCompletion:(void (^)(NSMutableArray *items, NSError *error))callBack{
    //get location
    //CLLocation *location = [LocationController sharedController].currentLocation;
    LocationController *locationController = [[LocationController alloc]init];

    
    //make request
    NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feed3.php?Latitude=%f&Longitude=%f&Radius=%f", locationController.locationManager.location.coordinate.latitude, locationController.locationManager.location.coordinate.longitude, radius];
    
    //NSString *urlAsString = @"https://n46.org/whereabt/feed3.php?Latitude=41.670689&Longitude=-83.643956&Radius=3.000000";
    //eventually, include radius in last parameter 'Radius='
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error){

                                                       NSError *jsonError = nil;
                                                       NSArray *immutable = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError]; // handle response
                                                       if (error == nil) {
                                                           error = jsonError;
                                                       }
                                                       else {
                                                           //this means the session data task error will be passed as parameter.
                                                       }
                                                       _itemCollection = [immutable mutableCopy];
                                                       
                                                       if (self.itemCollection == nil) {
                                                           NSLog(@"Problem occurred, no array from json. The error: %@", jsonError);
                                                       }
                                                       
                                                       else {
                                                       
                                                       NSLog(@"%@", _itemCollection);
                                                       for (NSDictionary *photoItem in _itemCollection) {
                                                           NSString *thumbPhotoURL = photoItem[@"ThumbnailURL"];
                                                           NSString *largPhotoURL = photoItem[@"PhotoURL"];
                                                           NSInteger photoItemIndex = [_itemCollection indexOfObject:photoItem];
                                                           [self imageFromURLString:thumbPhotoURL atIndex:photoItemIndex OfArray:_itemCollection isThumbnail:YES];
                                                           [self imageFromURLString:largPhotoURL atIndex:photoItemIndex OfArray:_itemCollection isThumbnail:NO];
                                                          // [self imageFromURLString:photoURL atIndex:photoItemIndex OfArray:_itemCollection];
                                                           
                                                           //when requests are done, call completion handler (callBack block) with request-created parameters
                                                           //callBack(_itemCollection, error);
                                                           
                                                        }
                                                        //callBack(_itemCollection, error);
                                                       }
                                                       callBack(_itemCollection, error);
                                                   }
                                             ];
    [dataRequestTask resume];
}


- (void)imageFromURLString:(NSString *)urlString atIndex:(NSInteger)index OfArray:(NSArray*)jsonArray isThumbnail:(BOOL) isThumbnail
{
    NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *photoRequestTask = [session dataTaskWithURL: url
                                                    completionHandler: ^(NSData *data,
                                                                         NSURLResponse *response,
                                                                         NSError *error) {
                                                        if (error == nil) {
                                                            UIImage *returnedImage = [UIImage imageWithData:data];
                                                            if (returnedImage != nil) {
                                                                 NSMutableDictionary *newDict = jsonArray[index];
                                                                if (isThumbnail == YES) {
                                                                    [newDict setObject:returnedImage forKey:@"ThumbnailPhoto"];
                                                                }
                                                                else{
                                                                    [newDict setObject:returnedImage forKey:@"LargePhoto"];
                                                                }
                                                                
                                                                [_itemCollection replaceObjectAtIndex:index withObject:newDict];

                                                            }
                                                        }
                                                        else {
                                                            NSLog(@"Error occurred while downloading image, add something here to alert user");
                                                        }
                                                    }
                                              ];
    
    [photoRequestTask resume];
}


@end

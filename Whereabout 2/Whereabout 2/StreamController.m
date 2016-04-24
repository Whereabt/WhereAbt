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
#import <Google/Analytics.h>

@implementation StreamController

- (void)getFeedWithType:(NSString *)streamType andCompletion:(void (^)(NSMutableArray *items, NSError *error))callBack{
    //get location
    //CLLocation *location = [LocationController sharedController].currentLocation;
    
    [LocationController sharedController];
    LocationController *locationController = [[LocationController alloc]init];
    
    //check to see if location working
    if (locationController.locationManager.location) {
        //make request
        NSUserDefaults *standards = [NSUserDefaults standardUserDefaults];
        
        NSString *urlAsString;
        if ([streamType isEqual: @"time"]) {
            float radius = [standards floatForKey:@"stream distance filter"];
            if (!radius) {
                radius = 5.00;
            }
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Time Sort Load"
                                                                  action:@"Radius"
                                                                   label:[NSString stringWithFormat:@"%f miles", radius]
                                                                   value:nil] build]];
            
            urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feedTest1.php?Latitude=%f&Longitude=%f&Radius=%f&Sort=time", locationController.locationManager.location.coordinate.latitude, locationController.locationManager.location.coordinate.longitude, radius];
        }
        else {
            float seconds = [standards floatForKey:@"stream time filter"] * 86400.00;
            if (!seconds) {
                seconds = 604800.00;
            }
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Distance Sort Load"
                                                                  action:@"Period"
                                                                   label:[NSString stringWithFormat:@"%f seconds", seconds]
                                                                   value:nil] build]];
             urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feedTest1.php?Latitude=%f&Longitude=%f&Sort=distance&Period=%f", locationController.locationManager.location.coordinate.latitude, locationController.locationManager.location.coordinate.longitude, seconds];
        }
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
                                                               
                                                           }
                                                           
                                                           for (int i = 0; i < self.itemCollection.count; i++) {
                                                               if ([_itemCollection[i][@"Viewable"]  isEqual: @"FALSE"]) {
                                                                   [_itemCollection removeObjectAtIndex:i];
                                                               }
                                                           }
                                                           
                                                           callBack(_itemCollection, error);
                                                       }
                                                 ];
        [dataRequestTask resume];

    }
    
    else {
       
        UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Instead of using your location we're just going to use the location currently showing the most activity." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [locationAlert show];
        
        NSUserDefaults *standards = [NSUserDefaults standardUserDefaults];
        
        NSString *urlAsString;
        if ([streamType isEqual: @"time"]) {
            float radius = [standards floatForKey:@"stream distance filter"];
            if (!radius) {
                radius = 5.00;
            }
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Time Sort Load"
                                                                  action:@"Radius"
                                                                   label:[NSString stringWithFormat:@"%f miles", radius]
                                                                   value:nil] build]];
            urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feedTest1.php?Latitude=41.670689&Longitude=-83.643956&Radius=3000.000000&Radius=%f&Sort=time", radius];
        }
        else {
            float seconds = [standards floatForKey:@"stream time filter"] * 86400.00;
            if (!seconds) {
                seconds = 604800.00;
            }
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Distance Sort Load"
                                                                  action:@"Period"
                                                                   label:[NSString stringWithFormat:@"%f seconds", seconds]
                                                                   value:nil] build]];
            urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feedTest1.php?Latitude=41.670689&Longitude=-83.643956&Radius=3000.000000&Sort=distance&Period=%f", seconds];
        }
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
                                                               
                                                           }
                                                           
                                                           for (int i = 0; i < self.itemCollection.count; i++) {
                                                               if ([_itemCollection[i][@"Viewable"]  isEqual: @"FALSE"]) {
                                                                   [_itemCollection removeObjectAtIndex:i];
                                                               }
                                                           }
                                                           callBack(_itemCollection, error);
                                                       }
                                                 ];
        [dataRequestTask resume];

        
        /*//make request
        NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feed3.php?Latitude=41.670689&Longitude=-83.643956&Radius=3000.000000"];
        
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
                                                               
                                                           }
                                                           callBack(_itemCollection, error);
                                                       }
                                                 ];
        [dataRequestTask resume]; */
    }
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

- (void)reportPhotoWithUserID: (NSString *)userId andPhotoID: (NSString *)photoId andReason: (NSString *)reasonID withCompletion:(void (^)(NSError *error))completionHandler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://n46.org/whereabt/reportPhoto.php?PhotoID=%@&UserID=%@&Reason=%@", photoId, userId, reasonID]];;
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"RESPONSE FROM REPORT: %@", response);
        
        completionHandler (error);
    }];
    [postDataTask resume];
}

- (void)getFeedFromAzureCloudFileWithRadius:(float)radius andCompletion:(void (^)(NSMutableArray *items, NSError *error))callBack {
    
        //make request
        NSString *urlAsString = [NSString stringWithFormat:@"https://whereaboutcloud.file.core.windows.net/feed/feed.php?Latitude=%f&Longitude=%f&Radius=%f", [LocationController sharedController].currentLocation.coordinate.latitude, [LocationController sharedController].currentLocation.coordinate.longitude, radius];
        
        NSURL *url = [[NSURL alloc] initWithString:urlAsString];
        NSLog(@"%@", urlAsString);
        
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:60.0];
        
        NSDate *currentDate = [[NSDate alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *localDateString = [dateFormatter stringFromDate:currentDate];

        [theRequest setHTTPMethod:@"GET"];
        
        [theRequest setValue:localDateString forHTTPHeaderField:@"x-ms-date"];
        
        //passing key as a http header request
        [theRequest addValue:@"SharedKey whereaboutcloud:iOZUM4RA1UfOKje24cz/VgkoQnSUR6UBg9ZpEFwOCnX8rJRjpCJuV3kpBybaGiLyfnGHBQqs4eN9bsAAOAm7SA==" forHTTPHeaderField:@"Authorization"];
        
        [theRequest addValue:@"2015-04-05" forHTTPHeaderField:@"x-ms-version"];
    
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
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
                
            }
            
            for (int i = 0; i < self.itemCollection.count; i++) {
                if ([_itemCollection[i][@"Viewable"]  isEqual: @"FALSE"]) {
                    [_itemCollection removeObjectAtIndex:i];
                }
            }
            
            callBack(_itemCollection, error);

        }];
        
        [downloadTask resume];
        
}




@end


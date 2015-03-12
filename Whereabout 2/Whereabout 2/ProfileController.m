//
//  ProfileController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/20/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ProfileController.h"
#import "WelcomeViewController.h"
#import "LocationController.h"

@implementation ProfileController

- (void)requestProfileItemsWithCompletion: (void (^)(NSArray *Items, NSError *error))callBack{
    LocationController *locationController = [[LocationController alloc] init];
    NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/userprofile.php?Latitude=%f&Longitude=%f&Radius=%d&UserID=%@", locationController.locationManager.location.coordinate.latitude, locationController.locationManager.location.coordinate.longitude, 10000, [WelcomeViewController sharedController].userID];
    NSLog(@"URL to get profile items: %@", urlAsString);
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    
    //create request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSArray *profileDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"JSON object with profile properties: %@", profileDict);
        callBack(profileDict, error);
        
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

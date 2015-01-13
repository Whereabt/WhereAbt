//
//  StreamLogic.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/12/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamLogic.h"
#import "LocationController.h"
#import "StreamViewController.h"

static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";

@implementation StreamLogic
{
    StreamLogic *logicManager;
}

+ (NSMutableArray*)getStreamLogicFromLocation:(CLLocation*)thisLocation WithObject:(StreamLogic*)
{
    
}

- (void)requestFeedWithClientLocation:(CLLocation*)location
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feed.php?Latitude=%f&Longitude=%f", location.coordinate.latitude, location.coordinate.longitude];
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error){
                                                       NSError *jsonError = nil;
                                                       NSArray *immutable = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError]; // handle response
                                                       logicManager.itemCollection = [immutable mutableCopy];
                                                       NSLog(@"%@", logicManager.itemCollection);
                                                       for (NSDictionary *photoItem in logicManager.itemCollection) {
                                                           NSString *photoURL = photoItem[photoURLIndex];
                                                           NSInteger photoItemIndex = [logicManager.itemCollection indexOfObject:photoItem];
                                                           [self imageFromURLString:photoURL atIndex:photoItemIndex];
                                                       }
                                                   }
                                             ];
    [dataRequestTask resume];
}

- (void)imageFromURLString:(NSString *)urlString atIndex:(NSInteger)index
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
                                                                 NSMutableDictionary *newDict = logicManager.itemCollection[index];
                                                                [newDict setObject:returnedImage forKey:photoIndex];
                                                            }
                                                        }
                                                    }
                                              ];
    
    [photoRequestTask resume];
}


@end

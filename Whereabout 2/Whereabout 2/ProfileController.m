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

- (void)getProfilePropertiesWithCompletion: (void (^)(NSDictionary *profileProperties, NSError *error))callBack{
        NSString *urlAsString = [NSString stringWithFormat:@"https://apis.live.net/v5.0/me?access_token=%@",[WelcomeViewController sharedController].authToken];
        NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    
       //create request
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSError *jsonError = nil;
                NSMutableDictionary *profileDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                NSLog(@"JSON object with profile properties: %@", profileDict);
            
                callBack(profileDict, error);
            
                }];
    
    [dataRequestTask resume];
    
}

- (void)deletePhotoFromDBWithPhotoID:(NSString *)photoId andCompletion:(void(^)(NSError *completionError))completionHandler {
    NSString *stringURL = [NSString stringWithFormat:@"https://n46.org/whereabt/deletephoto.php?PhotoID=%@", photoId];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    /*request.HTTPMethod = @"POST";
    NSString *post = [NSString stringWithFormat:@"product=%@", productName];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //content type header
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
     
    
    NSMutableDictionary *requestBodyDict = [[NSMutableDictionary alloc] init];
    [requestBodyDict setObject:productName forKey:@"product"];
    
    NSString *StringJSONbody = [self jsonStringFromDictionary:requestBodyDict];
        */
    
        //make task
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"RESPONSE FROM DELETE: %@", response);
        
        completionHandler(error);
    }];
    
    [postDataTask resume];

}

- (void)requestProfileItemsFromUser:(NSString *) Id WithCompletion: (void (^)(NSMutableArray *Items, NSError *error))callBack{
    LocationController *locationController = [[LocationController alloc] init];
    NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/userprofileTestFile.php?Latitude=%f&Longitude=%f&Radius=%d&UserID=%@", locationController.locationManager.location.coordinate.latitude, locationController.locationManager.location.coordinate.longitude, 10000, Id];
    NSLog(@"URL to get profile items: %@", urlAsString);
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    
    //create request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSArray *immutable = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (!error) {
            error = jsonError;
        }
        
        else {
            //don't need to do anything because the session data task error (if there is one) because it will automatically be passed to completion handler
        }
        self.itemCollection = [immutable mutableCopy];
        NSLog(@"JSON object of profileItems: %@", _itemCollection);
        
        /*
        for (NSDictionary *photoDict in self.itemCollection) {
            NSString *thumbPhotoURL = photoDict[@"ThumbnailURL"];
            NSString *largPhotoURL = photoDict[@"PhotoURL"];
            NSInteger photoItemIndex = [_itemCollection indexOfObject:photoDict];
            [self imageFromURLString:thumbPhotoURL atIndex:photoItemIndex OfArray:_itemCollection isThumbnail:YES];
            [self imageFromURLString:largPhotoURL atIndex:photoItemIndex OfArray:_itemCollection isThumbnail:NO];
            //NSArray *copy = [[NSArray alloc] init];
            //copy =[_itemCollection mutableCopy];
        }
         */
        
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

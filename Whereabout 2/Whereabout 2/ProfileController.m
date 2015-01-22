//
//  ProfileController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/20/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ProfileController.h"
#import "WelcomeViewController.h"

@implementation ProfileController

- (void)requestProfileItemsWithCompletion: (void (^)(NSDictionary *profileItems, NSError *error))callBack{
    NSString *urlAsString = [NSString stringWithFormat:@"https://apis.live.net/v5.0/me?access_token=%@",[WelcomeViewController sharedController].authToken];
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    
    //create request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSMutableDictionary *profileDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"JSON object with profile properties: %@", profileDict);
        callBack(profileDict, error);
        
        }
    ];
[dataRequestTask resume];
    
}

@end

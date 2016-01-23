//
//  n46UploadManager.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/13/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import "n46UploadManager.h"
#import <OneDriveSDK/OneDriveSDK.h>

@implementation n46UploadManager

- (void)PUTonNewPhotophpWithLocation:(CLLocation *)location andTime:(NSDate *)timeStamp WithImageURLsLarge:(NSString *)largeImage andUploadTime:(NSString *) uploadTime andPhotoId:(NSString *)imageID Mapping:(NSString *)mapping ImageSize:(NSString *)imageSize andCompletion:(void(^)(NSError *putError)) completionHandler {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [defaults objectForKey:@"UserID"], imageID];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate: timeStamp];
    NSString *fixedName = [[defaults objectForKey:@"UserName"] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSString *putString = [NSString stringWithFormat:@"https://n46.org/whereabt/newphotoTestFile.php?UserID=%@&PhotoID=%@&UserName=%@&Mapping=%@&Latitude=%f&Longitude=%f&PhotoURL=%@&ThumbnailURL=%@&TimeStamp=%@&UploadTime=%@", [defaults objectForKey:@"UserID"], imagePath, fixedName, mapping, location.coordinate.latitude, location.coordinate.longitude, largeImage, imageSize, dateString, uploadTime];
    NSLog(@"PUT URL String: %@", putString);
    
    NSURL *url = [[NSURL alloc]initWithString:putString];
    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error){
                                                       
                                                       completionHandler(error);
                                                       
                                                   }];
    [dataRequestTask resume];
}

- (void)createPhotoUploadTaskUsingImageName:(NSString *)imageName andImageData:(NSData *)imageData andCompletion:(void(^)(NSString *odUrl))completionHandler {
    
    NSString *path = [NSString stringWithFormat:@"WhereaboutApp/%@", imageName];
    ODClient *odclient = [ODClient loadCurrentClient];
    
    ODItemContentRequest *Request = [[[odclient root] itemByPath:path] contentRequest];
    
    [Request uploadFromData:imageData completion:^(ODItem *response, NSError *error) {
        
        NSLog(@"RESPONSE FROM UPLOAD: %@", response);
        if (error) {
            NSLog(@"Error uploading: %@", error);
        }
        
        else {
            //all good
            [self createShareLinkForODFileWithPath:path andCompletion:^(NSError *Error, NSString *odEscpPath) {
                
                if (!Error) {
                    NSLog(@"Success, no error on creating share link");
                }
                else {
                    UIAlertView *publicFolderAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a network error while trying to send your photo to the server. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [publicFolderAlert show];
                }
                completionHandler(odEscpPath);
                
            }];
            
        }
    }];
}

- (void)createShareLinkForODFileWithPath:(NSString *) ODfilePath andCompletion: (void (^)(NSError *Error, NSString *odEscpPath))theCallback {
    
    ODClient *currentClient = [ODClient loadCurrentClient];
    
    ODItemCreateLinkRequestBuilder *linkReqBuilder = [[[currentClient root]itemByPath:ODfilePath]createLinkWithType:@"edit"];
    
    ODItemCreateLinkRequest *linkReq = [linkReqBuilder request];
    
    [linkReq executeWithCompletion:^(ODPermission *response, NSError *error) {
        NSLog(@"SHARELINK RESPONSE: %@", response);
        NSString *escapedString = [[NSString alloc]init];
        if (error) {
            UIAlertView *shareLinkAlert = [[UIAlertView alloc] initWithTitle:@"Error occurred during upload" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [shareLinkAlert show];
        }
        
        else {
            NSLog(@"Success on shareLink request");
            
            NSLog(@"Link prop value: %@", response.link);
            NSString *unencodedShareURLstring = response.link.webUrl;
            escapedString = [unencodedShareURLstring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            escapedString = [escapedString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        }
        theCallback(error, escapedString);
    }];
    
}



@end

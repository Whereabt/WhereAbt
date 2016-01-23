//
//  n46UploadManager.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/13/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface n46UploadManager : NSObject

- (void)PUTonNewPhotophpWithLocation:(CLLocation *)location andTime:(NSDate *)timeStamp WithImageURLsLarge:(NSString *)largeImage andUploadTime:(NSString *) uploadTime andPhotoId:(NSString *)imageID Mapping:(NSString *)mapping ImageSize:(NSString *)imageSize andCompletion:(void(^)(NSError *putError)) completionHandler;

- (void)createPhotoUploadTaskUsingImageName:(NSString *)imageName andImageData:(NSData *)imageData andCompletion:(void(^)(NSString *odUrl))completionHandler;
@end

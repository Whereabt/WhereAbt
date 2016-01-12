//
//  UIImageView+ImgViewCat.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/11/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import "UIImageView+ImgViewCat.h"
#import "ReadWriteBlobsManager.h"


@implementation UIImageView (ImgViewCat)
/*
extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
*/

- (void) downloadImageFromLink:(NSString *)link andContentMode:(UIViewContentMode) contentMode withCompletionHandler:(void(^)()) success {
    
   // NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:PhotoUrlString]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:link] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *blobString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData *photoData = [[NSData alloc]initWithBase64EncodedString:blobString
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentMode = contentMode;
            if (photoData) {
                UIImage *img = [UIImage imageWithData:photoData];
                self.image = img;
                success();
            }
            else {
                NSLog(@"Error making image from data");
            }
        });
       
    }];
    [dataTask resume];
    
   /* NSArray *pathArray = [link componentsSeparatedByString:@"/"];
    
    ReadWriteBlobsManager *dwnldManager = [[ReadWriteBlobsManager alloc] init];
    [dwnldManager downloadBlob:pathArray[0] fromContainer:pathArray[1] ToStringWithCompletion:^(NSString *dataString, NSError *cbError) {
        NSData *photoData = [[NSData alloc]initWithBase64EncodedString:dataString
                                                               options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentMode = contentMode;
            if (photoData) {
                UIImage *img = [UIImage imageWithData:photoData];
                self.image = img;
            }
            else {
                NSLog(@"Error making image from data");
            }
        });

    }];
    */
}

@end

//
//  ImageCache.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/10/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCache : NSObject
@property (nonatomic, retain) NSCache *imgCache;


+ (ImageCache*)sharedImageCache;
- (void) AddImage:(NSString *)imageURL WithImage: (UIImage *)image;
- (UIImage *) GetImage:(NSString *)imageURL;
- (BOOL) DoesExist:(NSString *)imageURL;

@end

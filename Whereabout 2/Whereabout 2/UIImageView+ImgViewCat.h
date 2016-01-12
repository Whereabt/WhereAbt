//
//  UIImageView+ImgViewCat.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/11/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImgViewCat)

- (void) downloadImageFromLink:(NSString *)link andContentMode:(UIViewContentMode) contentMode withCompletionHandler:(void(^)()) success;

@end

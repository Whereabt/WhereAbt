//
//  EnlargeViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlargeViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *enlargedPhoto;

- (void)setUpTheEnlargedViewWithUsername:(NSString *)name andDistanceFrom:(NSString *)distance andPhoto:(UIImage *)photo;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end

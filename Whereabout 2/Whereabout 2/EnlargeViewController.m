//
//  EnlargeViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "EnlargeViewController.h"

@interface EnlargeViewController ()


@end
@implementation EnlargeViewController

NSString *Username;
NSString *Distance;
UIImage *EnlargedImage;

- (void)viewDidLoad {
    // Do any additional setup after loading the view from its nib.
    
    self.userNameLabel.text = Username;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ Miles", Distance];
    self.enlargedPhoto.image = EnlargedImage;
    self.enlargedPhoto.contentMode = UIViewContentModeScaleToFill;
    self.enlargedPhoto.userInteractionEnabled = YES;
    [super viewDidLoad];
    
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTheEnlargedViewWithUsername:(NSString *)name andDistanceFrom:(NSString *)distance andPhoto:(UIImage *)photo
{
    Username = name;
    Distance = distance;
    EnlargedImage = photo;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

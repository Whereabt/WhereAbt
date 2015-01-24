//
//  EnlargeViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlargeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *enlargedViewImage;

- (void)setImageForEnlargedImageUsingImage:(UIImage*) photo;

@end

//
//  OverlayView.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 6/29/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "OverlayView.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotosAccessViewController.h"

#define ROUND_BUTTON_WIDTH_HEIGHT 80

@implementation OverlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //image for overlay
        UIImage *overlayImage = [UIImage imageNamed:@"OverlayImage(2).jpg"];
        UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:overlayImage];
        overlayImageView.frame = CGRectMake(0, 40, 320, 300);
        overlayImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:overlayImageView];
        
        //button to take photo
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"OverlayImage.png"] forState:UIControlStateNormal];
        //[button setTitle:@"Go" forState:UIControlStateNormal];
        //button.frame = CGRectMake(0, 430, 320, 40);
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        //NSLog(@"center: %f", screenWidth/2);
        
        //40
        button.frame = CGRectMake((screenWidth/2) - (ROUND_BUTTON_WIDTH_HEIGHT/2), 430, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
        
        button.clipsToBounds = YES;
        button.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
        button.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f
                                                   green:153.0f/255.0f
                                                    blue:255.0f/255.0f
                                                   alpha:1.0f].CGColor;
        button.layer.borderWidth = 2.0f;
        
        [button addTarget:self action:@selector(CameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
    return self;
}



- (void)CameraButtonPressed {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    PhotosAccessViewController *photoController = [[PhotosAccessViewController alloc] init];
    [photoController takePhotoFromCamera];
}

@end

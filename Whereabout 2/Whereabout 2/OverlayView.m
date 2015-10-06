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

//80
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
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        //image for overlay
        UIImage *overlayImage = [UIImage imageNamed:@"OverlayImage(2).jpg"];
        UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:overlayImage];
        
        //300 height, 40 y, -528
        overlayImageView.frame = CGRectMake(0, (screenHeight - 480), 320, 300);
        overlayImageView.contentMode = UIViewContentModeCenter;
        overlayImageView.userInteractionEnabled = YES;
        [self addSubview:overlayImageView];
        
        //create button to take photo
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //overlayImage.png for orange
        [button setImage:[UIImage imageNamed:@"OverlayImage.png"] forState:UIControlStateNormal];

        
        //430 y, -138
        button.frame = CGRectMake((screenWidth/2) - (ROUND_BUTTON_WIDTH_HEIGHT/2), (screenHeight - 90), ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
        
        button.clipsToBounds = YES;
        button.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
        button.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f
                                                   green:153.0f/255.0f
                                                    blue:255.0f/255.0f
                                                   alpha:1.0f].CGColor;
        button.layer.borderWidth = 2.0f;
        
        [button addTarget:self action:@selector(CameraButtonPressed) forControlEvents:UIControlEventAllEvents];
        
        [self addSubview:button];
        
        //create close button
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f
                                                    green:153.0f/255.0f
                                                     blue:255.0f/255.0f
                                                    alpha:1.0f] forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"System" size:24]];
       
        
        closeButton.frame = CGRectMake(0, 0, 50, 50);
        [closeButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        //create button to switch between cameras
        UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [switchButton setTitle:@"Switch Camera" forState:UIControlStateNormal];
        [switchButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f
                                                    green:153.0f/255.0f
                                                     blue:255.0f/255.0f
                                                    alpha:1.0f] forState:UIControlStateNormal];
        switchButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        switchButton.frame = CGRectMake(self.frame.size.width - 110, 0, 110, 50);
        [switchButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchButton];
        
    }
    
    return self;
}

- (void)cancelButtonPressed {
    PhotosAccessViewController *photoController = [[PhotosAccessViewController alloc] init];
    [photoController cancelTakePhotoEvent];
}


- (void)CameraButtonPressed {
    PhotosAccessViewController *photoController = [[PhotosAccessViewController alloc] init];
    [photoController takePhotoFromCamera];
}

- (void)switchButtonPressed {
    PhotosAccessViewController *photoController = [[PhotosAccessViewController alloc] init];
    [photoController switchCamera];
}

@end

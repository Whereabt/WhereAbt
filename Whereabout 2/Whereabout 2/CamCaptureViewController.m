//
//  CamCaptureViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 12/29/15.
//  Copyright © 2015 Nicolas Isaza. All rights reserved.
//

#import "CamCaptureViewController.h"
#import "GPUImage.h"

@interface CamCaptureViewController ()
{
    GPUImageStillCamera *stillCamera;
    GPUImageFilter *filter;
}
@end

@implementation CamCaptureViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup initial camera filter
    filter = [[GPUImageFilter alloc] init];
    //[filter prepareForImageCapture];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    // Create custom GPUImage camera
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [stillCamera addTarget:filter];
    
    // Begin showing video camera stream
    [stillCamera startCameraCapture];
}

- (void)viewDidAppear:(BOOL)animated {
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[GPUImageGammaFilter alloc] init];
    
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    [stillCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

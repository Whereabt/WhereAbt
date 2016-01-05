//
//  CamCaptureViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 12/29/15.
//  Copyright © 2015 Nicolas Isaza. All rights reserved.
//

#import "CamCaptureViewController.h"
#import "GPUImage.h"
#import "ReadWriteBlobsManager.h"
#import "WelcomeViewController.h"
#import "FinalUploadViewController.h"

@interface CamCaptureViewController ()
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
}
@end

@implementation CamCaptureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //make filter button
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(applyImageFilter:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
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
    /*
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[GPUImageGammaFilter alloc] init];
    
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    [stillCamera startCameraCapture];
     */
}

- (IBAction)applyImageFilter:(id)sender
{
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Amatorka", @"Grayscale", @"Sepia Tone", @"Etikate", @"Elegance", @"None", nil];
    
    [filterActionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Bail if the cancel button was tapped
    if (actionSheet.cancelButtonIndex == buttonIndex)
    {
        return;
    }
    
    GPUImageOutput<GPUImageInput> *selectedFilter;
    
    [stillCamera removeAllTargets];
    [filter removeAllTargets];
    
    
    switch (buttonIndex) {
        case 0:
            selectedFilter = [[GPUImageAmatorkaFilter alloc] init];
            break;
        case 1:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 3:
            selectedFilter = [[GPUImageMissEtikateFilter alloc] init];
            break;
        case 4:
            selectedFilter = [[GPUImageSoftEleganceFilter alloc] init];
            break;
        case 5:
            selectedFilter = [[GPUImageFilter alloc] init];
            break;
        default:
            break;
    }
    
    filter = selectedFilter;
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    [stillCamera addTarget:filter];
    
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

- (IBAction)takePhotoPressed:(id)sender {
    //use default brightness (no effect)
    GPUImageBrightnessFilter *noFilter = [[GPUImageBrightnessFilter alloc] init];
    [stillCamera addTarget:noFilter];
    //use 'filter' for selected filter, use brightnessFilter for original photo (unfiltered)
    [stillCamera capturePhotoAsImageProcessedUpToFilter:noFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        //NSData *dataForJPEGFile = UIImageJPEGRepresentation(processedImage, 0.8);
        
       // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSMutableArray *imageSet = [[NSMutableArray alloc] init];
        imageSet[0] = processedImage;
        imageSet[1] = [[[GPUImageGrayscaleFilter alloc]init] imageByFilteringImage:processedImage];
        imageSet[2] = [[[GPUImageSepiaFilter alloc]init] imageByFilteringImage:processedImage];
        imageSet[3] = [[[GPUImageAmatorkaFilter alloc]init] imageByFilteringImage:processedImage];
        imageSet[4] = [[[GPUImageMissEtikateFilter alloc]init] imageByFilteringImage:processedImage];
        imageSet[5] = [[[GPUImageSoftEleganceFilter alloc]init] imageByFilteringImage:processedImage];
        
        FinalUploadViewController *finalUploadVC = [[FinalUploadViewController alloc] init];
        
        //must be done before initiating segue
        [finalUploadVC setCollectionViewDataSourceTo:imageSet];
        
        
        NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
        photoInfo[@"UserID"] = [WelcomeViewController sharedController].userID;
        photoInfo[@"PhotoID"] = [[NSProcessInfo processInfo]globallyUniqueString];
        
        //get data
        /*NSData *data = UIImagePNGRepresentation(processedImage);
        NSString *dataString = [NSString stringWithFormat:@"%@", data];
        photoInfo[@"Data-String"] = dataString;
        
        ReadWriteBlobsManager *blobManager = [[ReadWriteBlobsManager alloc] init];
        [blobManager uploadBlobToContainerWithPhotoDict:photoInfo];
         */
        [self performSegueWithIdentifier:@"segueToFinalUpload" sender:self];
    }];
}
@end

//
//  FilterCameraViewController.m
//  Pods
//
//  Created by Nicolas Isaza on 1/5/16.
//
//

#import "FilterCameraViewController.h"
#import "GPUImage.h"
#import "FinalUploadViewController.h"
#import "SWRevealViewController.h"

@interface FilterCameraViewController ()
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
}
@end
#define ROUND_BUTTON_WIDTH_HEIGHT 50

@implementation FilterCameraViewController
NSString *filterName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    UIButton *circleCamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [circleCamButton addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventAllEvents];
    
    //overlayImage.png for orange
    [circleCamButton setImage:[UIImage imageNamed:@"OverlayImage.png"] forState:UIControlStateNormal];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    
    //430 y, -138
    circleCamButton.frame = CGRectMake((screenWidth/2) - (ROUND_BUTTON_WIDTH_HEIGHT/2), 0, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    
    circleCamButton.clipsToBounds = YES;
    circleCamButton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    circleCamButton.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f
                                               green:153.0f/255.0f
                                                blue:255.0f/255.0f
                                               alpha:1.0f].CGColor;
    //self.takePhotoButton.image = [UIImage imageNamed:@"OverlayImage.png"];
    
   // self.takePhotoButton.customView = circleCamButton;
    
    //self.takePhotoButton = [[UIBarButtonItem alloc]initWithCustomView:circleCamButton];

    // Setup initial camera filter
    
    
    filter = [[GPUImageFilter alloc] init];
    //[filter prepareForImageCapture];

    GPUImageView *filterView = (GPUImageView *)self.view;
    NSLog(@"Camera Frame W: %f;H: %f; Y: %f; X: %f", filterView.frame.size.width, filterView.frame.size.height, filterView.frame.origin.y, filterView.frame.origin.x);
    
    //[filterView addSubview:switchCameraButton];

    [filter addTarget:filterView];
    
    // Create custom GPUImage camera
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [stillCamera addTarget:filter];
    filterName = @"None";
    [stillCamera startCameraCapture];
}

- (void) viewDidAppear:(BOOL)animated {

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
    
    filterName = [[NSString alloc] init];
    switch (buttonIndex) {
        case 0:
            selectedFilter = [[GPUImageAmatorkaFilter alloc] init];
            filterName = @"AMATORKA";
            break;
        case 1:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            filterName = @"GRAYSCALE";
            break;
        case 2:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            filterName = @"SEPIA TONE";
            break;
        case 3:
            selectedFilter = [[GPUImageMissEtikateFilter alloc] init];
            filterName = @"ETIKATE";
            break;
        case 4:
            selectedFilter = [[GPUImageSoftEleganceFilter alloc] init];
            filterName = @"ELEGANCE";
            break;
        case 5:
            selectedFilter = [[GPUImageFilter alloc] init];
            filterName = @"NONE";
            break;
        default:
            break;
    }
    
    filter = selectedFilter;
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    [stillCamera addTarget:filter];
}

/*
- (void)takePhotoButtonPressed {
    //WRONG

    //use default brightness (no effect)
    GPUImageBrightnessFilter *noFilter = [[GPUImageBrightnessFilter alloc] init];
    [stillCamera addTarget:noFilter];
    //use 'filter' for selected filter, use brightnessFilter for original photo (unfiltered)
    //WRONG
    [stillCamera capturePhotoAsImageProcessedUpToFilter:noFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        

        FinalUploadViewController *finalUploadVC = [[FinalUploadViewController alloc] init];
        NSLog(@"PROCESSED IMAGE: %@", processedImage);
        //must be done before initiating segue
        
        NSMutableArray *filterArray = [[NSMutableArray alloc] init];
        filterArray[0] = @"AMATORKA";
        filterArray[1] = @"GRAYSCALE";
        filterArray[2] = @"SEPIA TONE";
        filterArray[3] = @"ETIKATE";
        filterArray[4] = @"ELEGANCE";
        filterArray[5] = @"NONE";
        UIImage *filteredImage = [filter imageByFilteringImage:processedImage];
        
        
        NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
        photoInfo[@"Name"] = filterName;
        photoInfo[@"Image"] = filteredImage;
        
        filterArray[6] = photoInfo;
        filterArray[7] = processedImage;
        [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
        
        [finalUploadVC setCollectionViewDataSourceFromThisArray:filterArray];
        
        [self presentViewController:finalUploadVC animated:NO completion:^{
            //completion
        }];
        //[self performSegueWithIdentifier:@"segueToFinalUpload" sender:self];
    }];

}
*/
- (IBAction)takePhotoPressed:(id)sender {
    //use default brightness (no effect)
    
    self.takePhotoButton.enabled = NO;
    GPUImageBrightnessFilter *noFilter = [[GPUImageBrightnessFilter alloc] init];
    //[noFilter forceProcessingAtSize:CGSizeMake(300, 300)];
    [stillCamera addTarget:noFilter];
    //use 'filter' for selected filter, use brightnessFilter for original photo (unfiltered)
    
    //test
    [stillCamera useNextFrameForImageCapture];

    [stillCamera capturePhotoAsImageProcessedUpToFilter:noFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        //[stillCamera stopCameraCapture];
        UIView *blackView = [[UIView alloc]initWithFrame:self.view.frame];
        blackView.backgroundColor = [UIColor blackColor];
        //[self setView:blackView];
        
        FinalUploadViewController *finalUploadVC = [[FinalUploadViewController alloc] init];
        NSLog(@"PROCESSED IMAGE: %@", processedImage);
        //must be done before initiating segue
        
        //reduce image size
        //UIImage *reducedImg = [UIImage imageWithData:UIImageJPEGRepresentation(processedImage, 0.5)];
        
        
        NSMutableArray *filterArray = [[NSMutableArray alloc] init];
        filterArray[0] = @"AMATORKA";
        filterArray[1] = @"GRAYSCALE";
        filterArray[2] = @"SEPIA TONE";
        filterArray[3] = @"ETIKATE";
        filterArray[4] = @"ELEGANCE";
        filterArray[5] = @"NONE";
        UIImage *filteredImage = [filter imageByFilteringImage:processedImage];

        NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
        photoInfo[@"Name"] = filterName;
        photoInfo[@"Image"] = filteredImage;
        
        filterArray[6] = photoInfo;
        filterArray[7] = processedImage;
        [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];

        [finalUploadVC setCollectionViewDataSourceFromThisArray:filterArray];
        
        self.takePhotoButton.enabled = YES;
        
        if (processedImage) {
            [self performSegueWithIdentifier:@"segueToFinalUpload" sender:self];
        }
        else {
            
        }
        //[self presentViewController:finalUploadVC animated:YES completion:nil];
    }]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)filterItemPressed:(id)sender {
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Amatorka", @"Grayscale", @"Sepia Tone", @"Etikate", @"Elegance", @"None", nil];
    
    [filterActionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)switchItemPressed:(id)sender {
    
    [stillCamera rotateCamera];
}
@end

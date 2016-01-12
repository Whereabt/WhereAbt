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

@interface FilterCameraViewController ()
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
}
@end
#define ROUND_BUTTON_WIDTH_HEIGHT 80

@implementation FilterCameraViewController
NSString *filterName;

- (void)viewDidLoad {
    [super viewDidLoad];
    //make filter button
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(applyImageFilter:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    UIButton *circleCamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //overlayImage.png for orange
    [circleCamButton setImage:[UIImage imageNamed:@"OverlayImage.png"] forState:UIControlStateNormal];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    
    //430 y, -138
    circleCamButton.frame = CGRectMake((screenWidth/2) - (ROUND_BUTTON_WIDTH_HEIGHT/2), 0, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    
    circleCamButton.clipsToBounds = YES;
    circleCamButton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    circleCamButton.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f
                                               green:153.0f/255.0f
                                                blue:255.0f/255.0f
                                               alpha:1.0f].CGColor;
    
    //self.takePhotoButton = [[UIBarButtonItem alloc]initWithCustomView:circleCamButton];
    
    // Setup initial camera filter
    filter = [[GPUImageFilter alloc] init];
    //[filter prepareForImageCapture];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    // Create custom GPUImage camera
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [stillCamera addTarget:filter];
    filterName = @"None";
    // Begin showing video camera stream
    [stillCamera startCameraCapture];
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

- (IBAction)takePhotoPressed:(id)sender {
    //use default brightness (no effect)
    GPUImageBrightnessFilter *noFilter = [[GPUImageBrightnessFilter alloc] init];
    [stillCamera addTarget:noFilter];
    //use 'filter' for selected filter, use brightnessFilter for original photo (unfiltered)
    
  
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
        
        
        //NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
        //photoInfo[@"UserID"] = [WelcomeViewController sharedController].userID;
        //photoInfo[@"PhotoID"] = [[NSProcessInfo processInfo]globallyUniqueString];
        
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

@end

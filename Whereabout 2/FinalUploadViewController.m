//
//  FinalUploadViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 12/31/15.
//  Copyright © 2015 Nicolas Isaza. All rights reserved.
//

#import "FinalUploadViewController.h"
#import "GPUImage.h"
#import "ReadWriteBlobsManager.h"
#import "WelcomeViewController.h"
#import "PhotosAccessViewController.h"
#import "LocationController.h"
#import "n46UploadManager.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <OneDriveSDK/OneDriveSDK.h>
#import <JNKeychain/JNKeychain.h>

@import Photos;

@interface FinalUploadViewController ()
{
    UIBarButtonItem *upldButtonItem;
    BOOL fromCameraRoll;
}
@end

@implementation FinalUploadViewController
NSMutableArray *infoArray;
UIImageView *selectedImageView;
NSMutableDictionary *imageSetDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"AUTHENTICATION: %@", [JNKeychain loadValueForKey:@"AuthenticationMethod"]);
    //self.view.backgroundColor = [UIColor whiteColor];
    //add navigation bar upload button
    fromCameraRoll = NO;
    if (infoArray[6][@"Asset"]) {
        fromCameraRoll = YES;
    }
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //layout.minimumInteritemSpacing = 10;
    //layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //104 height works
    //415 y 44h
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 533, 320, 37) collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    _collectionView.scrollEnabled = YES;
    [self.view addSubview:_collectionView];
    
    selectedImageView = [[UIImageView alloc] init];

    [selectedImageView setImage: infoArray[6][@"Image"]];
    selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectedImageView setFrame:CGRectMake(0, 46, 320, 475)];
    [self.view addSubview:selectedImageView];

    [_collectionView reloadData];

}

- (IBAction)uploadButtonPress:(id)sender {
    UIActivityIndicatorView *uploadActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x - 20, self.view.center.y - 20, 40, 40)];
    uploadActivityIndicator.color = [UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    [selectedImageView addSubview:uploadActivityIndicator];
    [uploadActivityIndicator startAnimating];
    
    
    UIBarButtonItem *activityIndicatorItem = [[UIBarButtonItem alloc] initWithCustomView:uploadActivityIndicator];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:activityIndicatorItem];
    
    PHAsset *asset = infoArray[6][@"Asset"];
    if (fromCameraRoll) {
        if (asset.location) {
            [self uploadPhotoWithLocation:asset.location andTime:asset.creationDate];
        }
        else {
            UIBarButtonItem *navBarButt = [[UIBarButtonItem alloc]initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadButtonPress:)];
            
            [self.navigationController.navigationBar.topItem setRightBarButtonItem:navBarButt];
            

            UIAlertController *metadataLocationAlert = [UIAlertController alertControllerWithTitle:@"No stored location" message:@"This photo cannot be uploaded since it doesn't have a location stored in its metadata." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [metadataLocationAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [metadataLocationAlert addAction:okAction];
            [self presentViewController:metadataLocationAlert animated:YES completion:nil];
        }
    }
    
    else {
        if (![LocationController sharedController].currentLocation) {
            UIBarButtonItem *navBarButt = [[UIBarButtonItem alloc]initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadButtonPress:)];
            
            [self.navigationController.navigationBar.topItem setRightBarButtonItem:navBarButt];
            

            UIAlertController *LocationAlert = [UIAlertController alertControllerWithTitle:@"Could not retrieve your current location" message:@"Please make sure that we have access to your location in Settings." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [LocationAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [LocationAlert addAction:okAction];
            [self presentViewController:LocationAlert animated:YES completion:nil];

        }
        else {
            //check defults
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            if ([[preferences objectForKey:@"autoSave"]  isEqual: @"YES"]) {
                UIImageWriteToSavedPhotosAlbum(selectedImageView.image, nil, nil, nil);
            }
            
        [self uploadPhotoWithLocation:[LocationController sharedController].currentLocation andTime:[NSDate date]];
        }
    }
    
}

- (void)uploadPhotoWithLocation:(CLLocation *)locationTag andTime:(NSDate *) dateStamp {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    n46UploadManager *putManager = [[n46UploadManager alloc] init];
    
    NSDate *uploadStartTime = [NSDate date];
    ReadWriteBlobsManager *blobManager = [[ReadWriteBlobsManager alloc] init];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(selectedImageView.image, 0.5);
    
    // Log out the image size
    NSLog(@"IMAGE SIZE: %lu KB",(imageData.length/1024));
    
    NSString *stringImage = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    paramDict[@"Data-String"] = stringImage;
    
    paramDict[@"PhotoID"] = [[NSProcessInfo processInfo] globallyUniqueString];
    paramDict[@"UserID"] = [preferences objectForKey:@"UserID"];
    
    NSString *mappingPreference = [[NSString alloc]init];
    if ([[preferences objectForKey:@"mapping"]  isEqual: @"TRUE"]) {
        mappingPreference = @"TRUE";
    }
    else {
        mappingPreference = @"FALSE";
    }
    NSString *ImageHeight = [NSString stringWithFormat:@"%f", selectedImageView.image.size.height];
    NSLog(@"IMAGE HEIGHT: %@", ImageHeight);
    
    if (selectedImageView.image.size.height > 500) {
        ImageHeight = @"400.00";
    }
    
    //if has onedrive account, don't use blob storage
    NSLog(@"AUTHENTICATION: %@", [JNKeychain loadValueForKey:@"AuthenticationMethod"]);
    
    /*
    if ([[JNKeychain loadValueForKey:@"AuthenticationMethod"] isEqual: @"OneDriveAuthentication"]) {
        [putManager createPhotoUploadTaskUsingImageName:paramDict[@"PhotoID"] andImageData:imageData andCompletion:^(NSString *odUrl) {
            [putManager PUTonNewPhotophpWithLocation:locationTag andTime:dateStamp WithImageURLsLarge:odUrl andUploadTime:[NSString stringWithFormat:@"%f", uploadStartTime.timeIntervalSinceNow] andPhotoId:paramDict[@"PhotoID"] Mapping:mappingPreference ImageSize:ImageHeight andCompletion:^(NSError *putError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
                    
                    // upldButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uploadButton];
                    UIBarButtonItem *navBarButt = [[UIBarButtonItem alloc]initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadButtonPress:)];
                    
                    [self.navigationController.navigationBar.topItem setRightBarButtonItem:navBarButt];
                    
                });
                
                if (putError) {
                    NSLog(@"Error on n46 PUT");
                    
                    UIAlertController *putAlert = [UIAlertController alertControllerWithTitle:@"Could not connect to the server." message:@"Please check your network connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [putAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [putAlert addAction:okAction];
                    [self presentViewController:putAlert animated:YES completion:nil];
                    
                }
                else {
                    NSLog(@"Success on n46 PUT");
                }

            }];
        }];
    } */
    
        [blobManager uploadBlobToContainerWithPhotoDict:paramDict WithCompletion:^(NSError *cbError) {
            if (cbError) {
                NSLog(@"ERROR UPLOADING BLOB: %@", cbError);
            }
            else {
                NSLog(@"SUCCESS UPLOADING BLOB");
            
                    NSString *intervalsString = [NSString stringWithFormat:@"%f", uploadStartTime.timeIntervalSinceNow];
            
                    [putManager PUTonNewPhotophpWithLocation:locationTag andTime:dateStamp WithImageURLsLarge:@"BLOB" andUploadTime:intervalsString andPhotoId:paramDict[@"PhotoID"] Mapping:mappingPreference ImageSize:ImageHeight andCompletion:^(NSError *putError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
                        
                        // upldButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uploadButton];
                            UIBarButtonItem *navBarButt = [[UIBarButtonItem alloc]initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadButtonPress:)];
                        
                            [self.navigationController.navigationBar.topItem setRightBarButtonItem:navBarButt];
                        
                        });
                    
                        if (putError) {
                            NSLog(@"Error on n46 PUT");
                        
                            UIAlertController *putAlert = [UIAlertController alertControllerWithTitle:@"Could not connect to the server." message:@"Please check your network connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [putAlert dismissViewControllerAnimated:YES completion:nil];
                            }];
                        
                            [putAlert addAction:okAction];
                            [self presentViewController:putAlert animated:YES completion:nil];
                        
                        }
                        else {
                            NSLog(@"Success on n46 PUT");
                        }
                    }];
            
            
                NSLog(@"PHOTO ID: %@", paramDict[@"PhotoID"]);
            }
        }];
}

- (void)setCollectionViewDataSourceFromThisArray:(NSMutableArray *)filterList {
    infoArray = [[NSMutableArray alloc] initWithArray:filterList];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UILabel *filterLabel = [[UILabel alloc]init];
    filterLabel.textColor = [UIColor whiteColor];
    [filterLabel setFont:[UIFont systemFontOfSize:12]];

    //UIImage *imageToDisplay;
    if (indexPath.row == 0) {
        [filterLabel setText:@"AMATORKA"];
        //imageToDisplay = [[[GPUImageAmatorkaFilter alloc]init] imageByFilteringImage:unfilteredImage];
    }
    else if (indexPath.row == 1) {
        [filterLabel setText:@"GRAYSCALE"];
        //imageToDisplay = [[[GPUImageGrayscaleFilter alloc]init] imageByFilteringImage:unfilteredImage];
    }
    else if (indexPath.row == 2){
        [filterLabel setText:@"SEPIA TONE"];
        //imageToDisplay = [[[GPUImageSepiaFilter alloc]init] imageByFilteringImage:unfilteredImage];
    }
    else if (indexPath.row == 3){
        [filterLabel setText:@"ETIKATE"];
        //imageToDisplay = [[[GPUImageMissEtikateFilter alloc]init] imageByFilteringImage:unfilteredImage];
    }
    else if (indexPath.row == 4) {
        [filterLabel setText:@"ELEGANCE"];
        //imageToDisplay = [[[GPUImageSoftEleganceFilter alloc]init] imageByFilteringImage:unfilteredImage];
    }
    else if (indexPath.row == 5) {
        [filterLabel setText:@"NONE"];
    }
    
    if (filterLabel.text == infoArray[6][@"Name"]) {
        [filterLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    }
    
    /*UIImageView *cellImageView = [[UIImageView alloc] initWithImage:imageToDisplay];
    [cellImageView setFrame:CGRectMake(0, 0, 90, 71)];
     */
    [filterLabel setFrame:CGRectMake(0, 6, 90, 24)];
    [filterLabel setTextAlignment:NSTextAlignmentCenter];
    
    cell.backgroundView = filterLabel;
    //[cell.backgroundView addSubview:filterLabel];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(90, 36);
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![infoArray[6][@"Name"] isEqualToString:infoArray[indexPath.row]]) {

    infoArray[6][@"Image"] = selectedImageView.image;

    //index 5 on infoArray is always current
    switch (indexPath.row) {
        case 0:
            if (imageSetDict[@"AMATORKA"]) {
                [selectedImageView setImage:imageSetDict[@"AMATORKA"]];
            }
            else {
                GPUImageAmatorkaFilter *amatorkaFilter = [[GPUImageAmatorkaFilter alloc]init];
                [amatorkaFilter useNextFrameForImageCapture];
            [selectedImageView setImage:[amatorkaFilter imageByFilteringImage:infoArray[7]]];
            imageSetDict[@"AMATORKA"] = selectedImageView.image;
            }
            break;
        case 1:
            if (imageSetDict[@"GRAYSCALE"]) {
                [selectedImageView setImage:imageSetDict[@"GRAYSCALE"]];
            }
            else {
                GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc]init];
                [grayscaleFilter useNextFrameForImageCapture];
                [selectedImageView setImage:[grayscaleFilter imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"GRAYSCALE"] = selectedImageView.image;
            }

            break;
        case 2:
            if (imageSetDict[@"SEPIA TONE"]) {
                [selectedImageView setImage:imageSetDict[@"SEPIA TONE"]];
            }
            else {
                GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
                [selectedImageView setImage:[sepiaFilter imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"SEPIA TONE"] = selectedImageView.image;
            }

            break;
        case 3:
            if (imageSetDict[@"ETIKATE"]) {
                [selectedImageView setImage:imageSetDict[@"ETIKATE"]];
            }
            else {
                GPUImageMissEtikateFilter *etikateFilter = [[GPUImageMissEtikateFilter alloc]init];
                [etikateFilter useNextFrameForImageCapture];
                [selectedImageView setImage:[etikateFilter imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"ETIKATE"] = selectedImageView.image;
            }

            break;
        case 4:
            if (imageSetDict[@"ELEGANCE"]) {
                [selectedImageView setImage:imageSetDict[@"ELEGANCE"]];
            }
            else {
                GPUImageSoftEleganceFilter *eleganceFilter = [[GPUImageSoftEleganceFilter alloc]init];
                [eleganceFilter useNextFrameForImageCapture];
                [selectedImageView setImage:[eleganceFilter imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"ELEGANCE"] = selectedImageView.image;
            }

            break;
        case 5:
            [selectedImageView setImage:infoArray[7]];
            break;
        default:
            break;
        }
        
        if (imageSetDict.count > 1) {
            [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
        }
    infoArray[6][@"Name"] = infoArray[indexPath.row];
    infoArray[6][@"Image"] = selectedImageView.image;
        
    //prevent memory warning

    [_collectionView reloadData];
    }
    
    //done to prevent memory warning
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

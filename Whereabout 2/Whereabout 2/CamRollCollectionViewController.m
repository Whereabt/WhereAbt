//
//  CamRollCollectionViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/8/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import "CamRollCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CamRollCollectionViewCell.h"
#import "FinalUploadViewController.h"
@import Photos;

@interface CamRollCollectionViewController ()
{
    NSArray *thumbnailArray;
    NSArray *assetGroupArray;
}

@end

@implementation CamRollCollectionViewController

static NSString * const reuseIdentifier = @"CamRollCVCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[CamRollCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    
    
    [self getImageArrayFromCameraRollWithCompletion:^(NSArray *cameraRollImages) {
        thumbnailArray = cameraRollImages;
        [self.collectionView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes

    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    if (!thumbnailArray) {
        [self getImageArrayFromCameraRollWithCompletion:^(NSArray *cameraRollImages) {
            thumbnailArray = cameraRollImages;
            [self.collectionView reloadData];
            //[self scrollToBottom];
        }];
    }
}



-(void)scrollToBottom {
    //Scrolls to bottom of scroller
    CGPoint bottomOffset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.bounds.size.height);
    [self.collectionView setContentOffset:bottomOffset animated:YES];
}

- (void)getImageArrayFromCameraRollWithCompletion:(void(^)(NSArray *cameraRollImages))completionHandler {
    thumbnailArray = [[NSArray alloc] init];
    
    /*
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSInteger numberOfAssets = [group numberOfAssets];
        if (numberOfAssets > 0) {
            NSLog(@"numberOfPictures: %ld",(long)numberOfAssets);
            for (int i = 0; i < numberOfAssets; i++)  {
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:i] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    UIImage *img = [UIImage imageWithCGImage:[result thumbnail]];
                    if (img) {
                        [thumbnailSet addObject:img];
                    }
                }];
            }
        }
        completionHandler(thumbnailSet);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to access your camera roll." message:@"You can give us access to your camera roll in Settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }];
    */
    
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    NSMutableArray *thumbnailSet = [[NSMutableArray alloc] init];
    for (int i = 0; i < fetchResult.count; i++) {
        [[PHImageManager defaultManager] requestImageForAsset:fetchResult[i]
                                                   targetSize:CGSizeMake(90, 90)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:PHImageRequestOptionsVersionCurrent
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (result) {
                                                        [thumbnailSet addObject:result];
                                                    }
                                                    if (i == fetchResult.count - 1) {
                                                        completionHandler(thumbnailSet);
                                                    }
                                                }];
    }
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return thumbnailArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CamRollCollectionViewCell *cell = (CamRollCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //[cell.imageView setImage: thumbnailArray[indexPath.row]];
    //NSLog(@"IMAGE: %@", thumbnailArray[indexPath.row]);
    UIImageView *imgView = [[UIImageView alloc] initWithImage:thumbnailArray[indexPath.row]];
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = imgView;
    // Configure the cell
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //3 per row; 4 per column = about 3.5 and 5.7 (divide by)
    return CGSizeMake(self.view.window.frame.size.width / 3.2, self.view.window.frame.size.height / 5.0);
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    thumbnailArray = nil;
    [self.collectionView reloadData];
    
    
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    [[PHImageManager defaultManager] requestImageForAsset:fetchResult[indexPath.row]
                                               targetSize:self.view.frame.size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:PHImageRequestOptionsVersionCurrent
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                
                                                NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
                                                photoInfo[@"Name"] = @"NONE";
                                                NSLog(@"RESULT SIZE:  %lu KB",(UIImageJPEGRepresentation(result, 1.0).length/1024));
                                                if (UIImageJPEGRepresentation(result, 1.0).length/1024 > 100) {
                                                    photoInfo[@"Image"] = result;
                                                    PHAsset *imageAsset = [[PHAsset alloc]init];
                                                    imageAsset = fetchResult[indexPath.row];
                                                    photoInfo[@"Asset"] = imageAsset;
                                                    NSMutableArray *filterArray = [[NSMutableArray alloc] initWithCapacity:8];
                                                    filterArray[0] = @"AMATORKA";
                                                    filterArray[1] = @"GRAYSCALE";
                                                    filterArray[2] = @"SEPIA TONE";
                                                    filterArray[3] = @"ETIKATE";
                                                    filterArray[4] = @"ELEGANCE";
                                                    filterArray[5] = @"NONE";
                                                    filterArray[6] = photoInfo;
                                                    filterArray[7] = result;
                                                    
                                                    
                                                    FinalUploadViewController *finalUploadManager = [[FinalUploadViewController alloc] init];
                                                    [finalUploadManager setCollectionViewDataSourceFromThisArray:filterArray];
                                                    [self performSegueWithIdentifier:@"segueToFilter" sender:self];
                                                }

                                            }];
    
    /*
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSInteger numberOfAssets = [group numberOfAssets];
        if (numberOfAssets > 0) {
            NSLog(@"numberOfPictures: %ld",(long)numberOfAssets);
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
                    photoInfo[@"Name"] = @"NONE";
                    
                    ALAssetRepresentation *defaultRep = [result defaultRepresentation];
                    UIImage *fullImg = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
                    
                    if (fullImg) {
                        photoInfo[@"Image"] = fullImg;
                        NSMutableArray *filterArray = [[NSMutableArray alloc] initWithCapacity:8];
                        filterArray[0] = @"AMATORKA";
                        filterArray[1] = @"GRAYSCALE";
                        filterArray[2] = @"SEPIA TONE";
                        filterArray[3] = @"ETIKATE";
                        filterArray[4] = @"ELEGANCE";
                        filterArray[5] = @"NONE";
                        filterArray[6] = photoInfo;
                        filterArray[7] = fullImg;
                        
                        FinalUploadViewController *finalUploadManager = [[FinalUploadViewController alloc] init];
                        [finalUploadManager setCollectionViewDataSourceFromThisArray:filterArray];
                        [self performSegueWithIdentifier:@"segueToFilter" sender:self];

                    }

                }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to access your camera roll." message:@"You can give us access to your camera roll in Settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }];
     */
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

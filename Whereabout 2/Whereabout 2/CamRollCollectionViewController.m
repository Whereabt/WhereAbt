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
#import "SWRevealViewController.h"
#import "ImageCache.h"
#import <Google/Analytics.h>

@import Photos;

@interface CamRollCollectionViewController ()
{
    NSMutableArray *thumbnailCacheArray;
    NSMutableArray *assetGroupArray;
    PHFetchResult *FetchResult;
}

@end

@implementation CamRollCollectionViewController

static NSString * const reuseIdentifier = @"CamRollCVCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    
    [self.collectionView registerClass:[CamRollCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    thumbnailCacheArray = [[NSMutableArray alloc]init];

    [self getAssetArrayFromCameraRoll];
        //thumbnailCacheArray = cameraRollImages;
    [self.collectionView reloadData];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes

    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    if (!FetchResult) {
        [self getAssetArrayFromCameraRoll];
        
           // thumbnailArray = cameraRollImages;
            [self.collectionView reloadData];
            //[self scrollToBottom];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"camera roll vc"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)scrollToBottom {
    //Scrolls to bottom of scroller
    CGPoint bottomOffset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.bounds.size.height);
    [self.collectionView setContentOffset:bottomOffset animated:YES];
}

- (void)getAssetArrayFromCameraRoll {
    thumbnailCacheArray = [[NSMutableArray alloc] init];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    FetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    //NSMutableArray *thumbnailSet = [[NSMutableArray alloc] init];
    /*
    for (int i = 0; i < fetchResult.count; i++) {
        [[PHImageManager defaultManager] requestImageForAsset:fetchResult[i]
                                                   targetSize:CGSizeMake(90, 90)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:PHImageRequestOptionsVersionCurrent
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    PHAsset *asset = fetchResult[i];
                                                    if (result && asset.location) {
                                                        [thumbnailSet addObject:result];
                                                    }
                                                    if (i == fetchResult.count - 1) {
                                                        completionHandler(thumbnailSet);
                                                    }
                                                }];
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    thumbnailCacheArray = nil;
    
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
    return FetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CamRollCollectionViewCell *cell = (CamRollCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //placeholder
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"]];
    
    
    if ([[ImageCache sharedImageCache] DoesExist:FetchResult[indexPath.row]] == true) {
        [imgView setImage:[[ImageCache sharedImageCache] GetImage:FetchResult[indexPath.row]]];
    }
    else {
        [[PHImageManager defaultManager] requestImageForAsset:FetchResult[indexPath.row]
                                                   targetSize:self.view.frame.size
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:PHImageRequestOptionsVersionCurrent
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (result) {
                                                        [[ImageCache sharedImageCache] AddImage:FetchResult[indexPath.row] WithImage:result];
                                                        [imgView setImage:result];
                                                    }
                                                    
                                                }];
    }
    
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        cell.backgroundView = imgView;
        cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //3 per row; 4 per column = about 3.5 and 5.7 (divide by)
    return CGSizeMake(self.view.window.frame.size.width / 3.2, self.view.window.frame.size.height / 5.0);
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *photoInfo = [[NSMutableDictionary alloc] init];
    photoInfo[@"Name"] = @"NONE";
    UIImage *imgFromCache = [[ImageCache sharedImageCache] GetImage:FetchResult[indexPath.row]];
    
    photoInfo[@"Asset"] = FetchResult[indexPath.row];
    photoInfo[@"Image"] = imgFromCache;
    NSMutableArray *filterArray = [[NSMutableArray alloc] initWithCapacity:8];
    filterArray[0] = @"AMATORKA";
    filterArray[1] = @"GRAYSCALE";
    filterArray[2] = @"SEPIA TONE";
    filterArray[3] = @"ETIKATE";
    filterArray[4] = @"ELEGANCE";
    filterArray[5] = @"NONE";
    filterArray[6] = photoInfo;
    filterArray[7] = imgFromCache;
    
    FinalUploadViewController *finalUploadManager = [[FinalUploadViewController alloc] init];
    [finalUploadManager setCollectionViewDataSourceFromThisArray:filterArray];
    [self performSegueWithIdentifier:@"segueToFilter" sender:self];
    
    
    //thumbnailCacheArray = nil;
    //FetchResult = nil;
    //[self.collectionView reloadData];
    
   /* PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
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
                                                 PHAsset *asset = fetchResult[indexPath.row];
                                                if (UIImageJPEGRepresentation(result, 1.0).length/1024 > 50) {
                                                    photoInfo[@"Image"] = result;
                                                    photoInfo[@"Asset"] = asset;
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

                                            }];*/
    
    
    
   }

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 1;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewLayout.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
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

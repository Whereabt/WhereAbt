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

@interface FinalUploadViewController ()

@end

@implementation FinalUploadViewController
NSMutableArray *infoArray;
UIImageView *selectedImageView;
NSMutableDictionary *imageSetDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];

    //layout.minimumInteritemSpacing = 10;
    //layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //104 height works
    //415 y
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 475, 320, 44) collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];

    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.scrollEnabled = YES;
    [self.view addSubview:_collectionView];
    
    selectedImageView = [[UIImageView alloc] initWithImage:infoArray[6][@"Image"]];
    selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectedImageView setFrame:CGRectMake(0, 64, 320, 407)];
    [self.view addSubview:selectedImageView];
    
    [_collectionView reloadData];
    
}

- (void)setCollectionViewDataSourceFromThisArray:(NSMutableArray *)filterList {
    infoArray = [[NSMutableArray alloc] initWithArray:filterList];
}

- (IBAction)uploadButtonPressed:(id)sender {
    ReadWriteBlobsManager *blobManager = [[ReadWriteBlobsManager alloc] init];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    NSData *imageData = UIImagePNGRepresentation(selectedImageView.image);

    paramDict[@"Data-String"] = (__bridge id _Nullable)([imageData bytes]);
    paramDict[@"UserID"] = [WelcomeViewController sharedController].userID;
    
    paramDict[@"PhotoID"] = [[NSProcessInfo processInfo] globallyUniqueString];
    
    [blobManager uploadBlobToContainerWithPhotoDict:paramDict WithCompletion:^(NSError *cbError) {
        if (cbError) {
            NSLog(@"ERROR UPLOADING BLOB: %@", cbError);
        }
        else {
            NSLog(@"SUCCESS UPLOADING BLOB");
        }
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UILabel *filterLabel = [[UILabel alloc]init];
    filterLabel.textColor = [UIColor blackColor];
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
    cell.backgroundColor = [UIColor whiteColor];
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
            [selectedImageView setImage:[[[GPUImageAmatorkaFilter alloc]init] imageByFilteringImage:infoArray[7]]];
            imageSetDict[@"AMATORKA"] = selectedImageView.image;
            }
            break;
        case 1:
            if (imageSetDict[@"GRAYSCALE"]) {
                [selectedImageView setImage:imageSetDict[@"GRAYSCALE"]];
            }
            else {
                [selectedImageView setImage:[[[GPUImageGrayscaleFilter alloc]init] imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"GRAYSCALE"] = selectedImageView.image;
            }

            break;
        case 2:
            if (imageSetDict[@"SEPIA TONE"]) {
                [selectedImageView setImage:imageSetDict[@"SEPIA TONE"]];
            }
            else {
                [selectedImageView setImage:[[[GPUImageSepiaFilter alloc]init] imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"SEPIA TONE"] = selectedImageView.image;
            }

            break;
        case 3:
            if (imageSetDict[@"ETIKATE"]) {
                [selectedImageView setImage:imageSetDict[@"ETIKATE"]];
            }
            else {
                [selectedImageView setImage:[[[GPUImageMissEtikateFilter alloc]init] imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"ETIKATE"] = selectedImageView.image;
            }

            break;
        case 4:
            if (imageSetDict[@"ELEGANCE"]) {
                [selectedImageView setImage:imageSetDict[@"ELEGANCE"]];
            }
            else {
                [selectedImageView setImage:[[[GPUImageSoftEleganceFilter alloc]init] imageByFilteringImage:infoArray[7]]];
                imageSetDict[@"ELEGANCE"] = selectedImageView.image;
            }

            break;
        case 5:
            [selectedImageView setImage:infoArray[7]];
            break;
        default:
            break;
        }
    infoArray[6][@"Name"] = infoArray[indexPath.row];
    infoArray[6][@"Image"] = selectedImageView.image;
    [_collectionView reloadData];
    }
    
    //done to prevent memory warning
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

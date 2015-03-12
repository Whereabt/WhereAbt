//
//  CollectionStreamViewControllerCollectionViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamCollectionViewController.h"
#import "StreamController.h"
#import "StreamCollectionViewCell.h"
#import "DetailStreamViewController.h"
#import "StreamUpperSuppViewController.h"
#import "EnlargeViewController.h"
#include <math.h>

NSString *kCellID = @"cellID";

static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";


@interface StreamCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *streamItems;
@end


@implementation StreamCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerClass: [StreamCollectionViewCell class]forCellWithReuseIdentifier:kCellID];
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flow];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0);
    
    self.StreamActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.StreamActivity.hidesWhenStopped = YES;
    [self.StreamActivity startAnimating];
    
    //create object to deal with network requests
    StreamController *networkRequester = [[StreamController alloc] init];
    
    //ADD Slider and change radius parameter to its value
    [networkRequester getFeedWithRadius:2 andCompletion:^(NSMutableArray *items, NSError *error) {
        if (!error) {
            self.streamItems = items;
            
            /*
            //loop through the stream array and make sure images are not nil
            for (int i = 0; i < self.streamItems.count; i++) {
                if ((self.streamItems[i][@"ThumbnailPhoto"] == nil) || (self.streamItems[i][@"LargePhoto"] == nil)) {
                    [self.streamItems removeObjectAtIndex:i];
                }
            } */
            [self.collectionView reloadData];
            [self.StreamActivity stopAnimating];
            
        }
        
        else{
            NSLog(@"Error getting streamItems: %@", error);
            UIAlertView *streamFailAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"Sorry, we were unable to retrieve nearby photos from the server. Make sure that your phone is connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [streamFailAlert show];
        }
    }];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
   // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue destinationViewController];
    
    // Pass the selected object to the new view controller.
}


- (void)updateCollectionViewWithSliderValueChange:(NSInteger) value {
    StreamController *networkRequester = [[StreamController alloc] init];
    [networkRequester getFeedWithRadius:value andCompletion:^(NSMutableArray *items, NSError *error) {
        if (!error) {
            self.streamItems = items;
            
            /*
            UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
            [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
            [self.collectionView setCollectionViewLayout:flow animated:YES];
            
            UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
            collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 40, 10);
             */
        
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
             
        }
        
        else{
            NSLog(@"Error getting streamItems: %@", error);
            
            //error handling for end-user
            UIAlertView *streamSliderAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a problem while trying to download nearby photos. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [streamSliderAlert show];
        }
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.streamItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   StreamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[StreamCollectionViewCell alloc]init];
    }
   
    //use "ThumbnailPhoto" or "LargePhoto"
    UIImage *imageReturned = self.streamItems[indexPath.row][@"ThumbnailPhoto"];
    
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    UIImageView *imageSubview = [[UIImageView alloc] initWithFrame:cellView.frame];
    imageSubview.image = imageReturned;
    imageSubview.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview: imageSubview];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView.frame = cell.frame;
    cell.backgroundView = cellView;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(60.0f, 60.0f);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    StreamUpperSuppViewController *reusableHeader = nil;
    if ([kind isEqual:UICollectionElementKindSectionHeader] == YES) {
        reusableHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [reusableHeader sizeToFit];
    }
    
    return reusableHeader;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     //3 per row; 4 per column = about 3.5 and 5.7 (divide by)
    return CGSizeMake(self.view.window.frame.size.width / 3.2, self.view.window.frame.size.height / 5.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 2.0;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    EnlargeViewController *EnlargeManager = [[EnlargeViewController alloc] init];
    /*
    double latitudeInteger = [self.streamItems[indexPath.row][@"Latitude"] doubleValue];
    NSString *latitudeString = [NSString stringWithFormat:@"%.3f", latitudeInteger];
    NSLog(@"Latitude string: %@", latitudeString);
    
    double longitudeInteger = [self.streamItems[indexPath.row][@"Longitude"] doubleValue];
    NSString *longitudeString = [NSString stringWithFormat:@"%.3f",longitudeInteger];
     
    NSString *coordinatePairString = [NSString stringWithFormat:@"(%@, %@)", latitudeString, longitudeString];
    */
    
    double distanceInt = [self.streamItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceString = [NSString stringWithFormat:@"%.3f", distanceInt];
    
    UIImage *Image = self.streamItems[indexPath.row][@"LargePhoto"];
    [EnlargeManager setUpTheEnlargedViewWithUsername:self.streamItems[indexPath.row][@"UserName"] locationCoordinates:distanceString andPhoto:Image];
    [self performSegueWithIdentifier:@"segueToEnlargeNav" sender:self];
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

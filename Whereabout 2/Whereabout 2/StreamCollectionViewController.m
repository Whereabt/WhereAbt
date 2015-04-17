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
#import "StreamEnlarge&SaveViewController.h"
#include <math.h>
#include <QuartzCore/QuartzCore.h>

NSString *kCellID = @"cellID";

static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";


@interface StreamCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *streamItems;
@end


@implementation StreamCollectionViewController

UIImage *imageToSave;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self refreshStream];
    

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

//method to be called by refresh control and on viewDidLoad
- (void)refreshStream
{
    self.StreamActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.StreamActivity.hidesWhenStopped = YES;
    
    [self.collectionView bringSubviewToFront:self.StreamActivity];
    [self.StreamActivity startAnimating];
    
    self.collectionView.alwaysBounceVertical = YES;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass: [StreamCollectionViewCell class]forCellWithReuseIdentifier:kCellID];
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flow];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    //create object to deal with network requests
    StreamController *networkRequester = [[StreamController alloc] init];
    
    //get default radius
    float f;
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences floatForKey:@"Radius Slider"] * 3 == 0) {
        f = 1.5;
    }
    else {
    f = [preferences floatForKey:@"Radius Slider"] * 3;
    }
    
    NSLog(@"Radius: %f", f);
    
    [networkRequester getFeedWithRadius:f andCompletion:^(NSMutableArray *items, NSError *error) {
        if (!error) {
            self.streamItems = items;
            
            /*
             //loop through the stream array and make sure images are not nil
             for (int i = 0; i < self.streamItems.count; i++) {
             if ((self.streamItems[i][@"ThumbnailPhoto"] == nil) || (self.streamItems[i][@"LargePhoto"] == nil)) {
             [self.streamItems removeObjectAtIndex:i];
             }
             } */
            
            //[self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
            [self.collectionView reloadData];
            
            /*
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            */
             
            if ([self.StreamActivity isAnimating] == YES) {
                [self.StreamActivity stopAnimating];
            }
            else {
                //do nothing if for some reason the indicator was not animating
            }
           
        }
        
        else{
            NSLog(@"Error getting streamItems: %@", error);
            [self.StreamActivity stopAnimating];
            UIAlertView *streamFailAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"Sorry, we were unable to retrieve nearby photos from the server. Make sure that your device is connected to the internet and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [streamFailAlert show];
        }
    }];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue destinationViewController];
    
    // Pass the selected object to the new view controller.
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self refreshStream];
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
        cell = [[StreamCollectionViewCell alloc] init];
    }
   
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    //if it has an image, continue with labels and more; otherwise, the cell will be nearly invisible
    if (self.streamItems[indexPath.row][@"LargePhoto"] != nil) {
        
        //use "ThumbnailPhoto" or "LargePhoto"
        UIImage *imageReturned = self.streamItems[indexPath.row][@"LargePhoto"];
        //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.streamItems[indexPath.row][@"PhotoURL"]]];
        //UIImage *imageReturned = [UIImage imageWithData:imageData];
        
        UIImageView *imageSubview = [[UIImageView alloc] initWithFrame:cellView.frame];
        imageSubview.image = imageReturned;
        imageSubview.contentMode = UIViewContentModeScaleAspectFit;
        
        [cellView addSubview: imageSubview];

        
        UILabel *DistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake (imageSubview.frame.origin.x, imageSubview.frame.origin.y, self.view.window.frame.size.width, 21)];
        
        double distanceInt = [self.streamItems[indexPath.row][@"MilesAway"] doubleValue];
        NSString *distanceString = [NSString stringWithFormat:@"%.3f Miles ", distanceInt];
        DistanceLabel.text = distanceString;
        DistanceLabel.font = [UIFont fontWithName: @"Arial Rounded MT Bold" size:12];
        DistanceLabel.numberOfLines = 1;
        DistanceLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        DistanceLabel.adjustsFontSizeToFitWidth = YES;
        DistanceLabel.textAlignment = NSTextAlignmentCenter;
        DistanceLabel.textColor = [UIColor whiteColor];
        [cellView addSubview:DistanceLabel];
        
        
        /*
        UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake (imageSubview.frame.origin.x, imageSubview.frame.origin.y, self.view.window.frame.size.width, 21)];
        NameLabel.font = [UIFont fontWithName: @"Farah" size:17];
        NameLabel.numberOfLines = 1;
        NameLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        NameLabel.adjustsFontSizeToFitWidth = YES;
        NameLabel.textAlignment = NSTextAlignmentLeft;
        NameLabel.textColor = [UIColor whiteColor];
        NSString *nameString = [NSString stringWithFormat:@"%@", self.streamItems[indexPath.row][@"UserName"]];
        
        NSArray *firstLastName = [nameString componentsSeparatedByString:@"_"];
        NameLabel.text = [NSString stringWithFormat:@"%@ %@", firstLastName[0], firstLastName[1]];
        [cellView addSubview:NameLabel];
        */
        
    }
    
    else {
        cell.backgroundView.frame = CGRectMake(0, 0, 0, 0);
        //no image could be found, hopefully the empty cell isn't noticeable
    }
    
    //cell.backgroundColor = [UIColor colorWithRed:0 green:0.153 blue:0.255 alpha:1.0];
    StreamEnlarge_SaveViewController *saveViewController = [[StreamEnlarge_SaveViewController alloc] init];
    cell.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                    green:33.0f/255.0f
                     blue:36.0f/255.0f
                    alpha:1.0f];
    //cellView.backgroundColor = [saveViewController getBackgroundColor];
    cell.backgroundView.frame = cell.frame;
    cell.backgroundView = cellView;
    
    return cell;
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(60.0f, 60.0f);
}
 */

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    StreamUpperSuppViewController *reusableHeader = nil;
    if ([kind isEqual:UICollectionElementKindSectionHeader] == YES) {
        reusableHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        float n = [preferences floatForKey:@"Radius Slider"] * 3;
        
        [reusableHeader.selectedRadiusLabel setText: [NSString stringWithFormat:@"Within %f Miles", n]];
         
        [reusableHeader sizeToFit];
    }
    
    return reusableHeader;
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     //3 per row; 4 per column = about 3.5 and 5.7 (divide by)
    //return CGSizeMake(self.view.window.frame.size.width / 3.2, self.view.window.frame.size.height / 5.0);
    
    UIImageView *sizeImageView = [[UIImageView alloc] initWithImage: self.streamItems[indexPath.row][@"LargePhoto"]];
    sizeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return CGSizeMake(self.view.window.frame.size.width, sizeImageView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 2.0;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    /*
    double latitudeInteger = [self.streamItems[indexPath.row][@"Latitude"] doubleValue];
    NSString *latitudeString = [NSString stringWithFormat:@"%.3f", latitudeInteger];
    NSLog(@"Latitude string: %@", latitudeString);
    
    double longitudeInteger = [self.streamItems[indexPath.row][@"Longitude"] doubleValue];
    NSString *longitudeString = [NSString stringWithFormat:@"%.3f",longitudeInteger];
     
    NSString *coordinatePairString = [NSString stringWithFormat:@"(%@, %@)", latitudeString, longitudeString];
    */
     
    NSMutableDictionary *dictionaryParameter = [[NSMutableDictionary alloc] init];
    
    double distanceInt = [self.streamItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceAwayString = [NSString stringWithFormat:@"%.3f", distanceInt];
    
    UIImage *Image = self.streamItems[indexPath.row][@"LargePhoto"];
    
    [dictionaryParameter setObject:distanceAwayString forKey:@"Distance"];
    [dictionaryParameter setObject:Image forKey:@"Photo"];
    [dictionaryParameter setObject:self.streamItems[indexPath.row][@"UserID"] forKey:@"ID"];
    [dictionaryParameter setObject:self.streamItems[indexPath.row][@"UserName"] forKey:@"Name"];
    
    StreamEnlarge_SaveViewController *SaveController = [[StreamEnlarge_SaveViewController alloc] init];
    [SaveController setUpTheEnlargedViewWithItemDictionary:dictionaryParameter];
    
    [self performSegueWithIdentifier:@"segueToEnlargeSave" sender:self];
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

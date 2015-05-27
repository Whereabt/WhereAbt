//
//  StreamPROCollectionViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamPROCollectionViewController.h"
#import "ProfileController.h"
#import "ProfileCVCell.h"
#import "StreamPROCollectionHeaderView.h"
#import "StreamPROEnlargedViewController.h"

@interface StreamPROCollectionViewController ()

//holds the items from the JSON Array
@property (strong, nonatomic) NSMutableArray *allProfileItems;
@end

@implementation StreamPROCollectionViewController

NSString *UserID;

static NSString * const reuseIdentifier = @"MyCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshStreamProfile];
}

- (void)refreshStreamProfile {
    self.profileActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.profileActivityIndicator.color = [UIColor orangeColor];
    self.profileActivityIndicator.hidesWhenStopped = YES;
    [self.profileActivityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ProfileCVCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flow];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    //get the profile items (images)
    ProfileController *profileController = [[ProfileController alloc] init];
    [profileController requestProfileItemsFromUser:UserID WithCompletion:^(NSMutableArray *Items, NSError *error) {
        
        if (!error) {
            self.allProfileItems = [Items mutableCopy];
            
            /*
             //delete null images
             NSMutableArray *NullItemsIndexes = [[NSMutableArray alloc] init];
             for (int i = 0; i < self.profileItems.count; i++) {
             if ((self.profileItems[i][@"ThumbnailPhoto"] == nil) || (self.profileItems[i][@"LargePhoto"] == nil)) {
             NSString *nullIndex = [NSString stringWithFormat:@"%d", i];
             [NullItemsIndexes addObject:nullIndex];
             }
             }
             
             for (NSString *nullIndexString in NullItemsIndexes) {
             NSInteger index = [nullIndexString integerValue];
             [_profileItems removeObjectAtIndex:index];
             NSLog(@"Deleted a null item inside of 'profileItems' array");
             }
             */
            [self.collectionView reloadData];
            
            NSLog(@"Finished fetching profileItems");
            if ([self.profileActivityIndicator isAnimating] == YES) {
                [self.profileActivityIndicator stopAnimating];
            }
            else {
                //do nothing if for some reason the indicator was not animating
            }
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        else {
            NSLog(@"Error getting profile items: %@", error);
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            if (error.code == 3840) {
                //user has 0 items in profile
                [self.profileActivityIndicator stopAnimating];
            }
            
            else {
                UIAlertView *failedToGetProfileItems = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We were unable to retrieve your photos from the server. Please make sure that your device is connected to the internet and try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [self.profileActivityIndicator stopAnimating];
                [failedToGetProfileItems show];
            }

            
        }
        
    }];
}


//this will pass the userID from the delegate method in the Stream to this vc
- (void)setUpProfileWithUserID:(NSString *) userId {
    UserID = userId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)streamPRORefreshButtonPress:(id)sender {
    
    [self refreshStreamProfile];
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

    return self.allProfileItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (!cell) {
        cell = [[ProfileCVCell alloc] init];
    }
    
    //use "ThumbnailPhoto" or "LargePhoto"
    UIImage *imageReturned = self.allProfileItems[indexPath.row][@"ThumbnailPhoto"];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    UIImageView *imageSubview = [[UIImageView alloc] initWithFrame:cellView.frame];
    imageSubview.image = imageReturned;
    imageSubview.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview: imageSubview];
    
    cell.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                           green:33.0f/255.0f
                                            blue:36.0f/255.0f
                                           alpha:1.0f];
    cell.backgroundView.frame = cell.frame;
    cell.backgroundView = cellView;
    return cell;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    StreamPROCollectionHeaderView *reusableHeader = nil;
    if ([kind isEqual:UICollectionElementKindSectionHeader] == YES) {
        reusableHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        [reusableHeader sizeToFit];
    }
    
    NSString *nameString = self.allProfileItems[indexPath.row][@"UserName"];
    NSArray *firstLastName = [nameString componentsSeparatedByString:@"_"];
    
    reusableHeader.firstNameLabel.text = firstLastName[0];
    reusableHeader.lastNameLabel.text = firstLastName[1];
    reusableHeader.postsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.allProfileItems.count];
    
    return reusableHeader;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.window.frame.size.width, 100.0f);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StreamPROEnlargedViewController *EnlargedViewManager = [[StreamPROEnlargedViewController alloc] init];
    
    double distanceInt = [self.allProfileItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceAwayString = [NSString stringWithFormat:@"%.3f", distanceInt];
    
    UIImage *Image = self.allProfileItems[indexPath.row][@"LargePhoto"];
    NSMutableDictionary *parameterDict = [[ NSMutableDictionary alloc] init];
    parameterDict[@"photo"] = Image;
    parameterDict[@"distance"] = distanceAwayString;
    parameterDict[@"time"] = self.allProfileItems[indexPath.row][@"TimeStamp"];
    
    [EnlargedViewManager setUpEnlargedViewWithDict: parameterDict];
    
    //go to the enlarged view
    [self performSegueWithIdentifier:@"segueEnlargedImage" sender:self];
}


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

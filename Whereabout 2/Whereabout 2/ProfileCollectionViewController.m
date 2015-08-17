//
//  ProfileCollectionCollectionViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 2/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "ProfileController.h"
#import "ProfileCVCell.h"
#import "ProfileViewHeaderView.h"
#import "WelcomeViewController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "ProfileEnlargedViewController.h"
#import "NSNetworkConnection.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileCollectionViewController ()

//holds items from JSON Array
@property (strong, nonatomic) NSMutableArray *profileItems;
@end

@implementation ProfileCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
UILabel *internetConnLabel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self refreshProfile];
     
    // Do any additional setup after loading the view.
}


- (void)refreshProfile {
    
    NSNetworkConnection *NetworkManager = [[NSNetworkConnection alloc] init];
    
    if ([NetworkManager doesUserHaveInternetConnection]){
        
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
        
    self.userProfileActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.userProfileActivityIndicator.color = [UIColor orangeColor];
    self.userProfileActivityIndicator.hidesWhenStopped = YES;
    [self.userProfileActivityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ProfileCVCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    //[self.collectionView setCollectionViewLayout:flow];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    NSLog(@"User id: %@",[WelcomeViewController sharedController].userID);
    
    //get the profile items (images)
    ProfileController *profileController = [[ProfileController alloc] init];
    [profileController requestProfileItemsFromUser:[WelcomeViewController sharedController].userID WithCompletion:^(NSMutableArray *Items, NSError *error){
        
        if (!error) {
            self.profileItems = [Items mutableCopy];
            
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
            NSLog(@"Finished fetching profileItems");
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.userProfileActivityIndicator isAnimating] == YES) {
                    [self.userProfileActivityIndicator stopAnimating];
                }
                else {
                    //do nothing if for some reason the indicator was not animating
                }
                [self.collectionView reloadData];
            });

            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        }
        else {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

            NSLog(@"Error getting profile items: %@", error);
            
            if (error.code == 3840) {
                //user has 0 items in profile
                NSLog(@"Current thread: %@", [NSThread currentThread]);
                [self.userProfileActivityIndicator stopAnimating];
                [self.userProfileActivityIndicator removeFromSuperview];
            }
            
            else {
                UIAlertView *failedToGetProfileItems = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We were unable to retrieve your photos from the server. Please make sure that your device is connected to the internet and try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [self.userProfileActivityIndicator stopAnimating];
                
                [failedToGetProfileItems show];
            }
        }
        
    }];
    
    }
    
    else {
        NSLog(@"NO CONNECTION");
        
        if ([internetConnLabel superview] == nil) {

        internetConnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        //connectionFailLabel.center = CGPointMake(0.0f, 64.0f);
        [internetConnLabel setText:@"No Internet Connection"];
        [internetConnLabel setTextAlignment:NSTextAlignmentCenter];
        internetConnLabel.backgroundColor = [UIColor grayColor];
        internetConnLabel.textColor = [UIColor whiteColor];
        [self.collectionView addSubview:internetConnLabel];
        
        NSTimer *connectionFailViewTimer = [NSTimer timerWithTimeInterval:3.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:connectionFailViewTimer forMode:NSDefaultRunLoopMode];
        }
    }
    
    // Do any additional setup after loading the view.

}

- (void)timerFireMethod:(NSTimer *)timer {
    if ([internetConnLabel superview] != nil) {
        [internetConnLabel removeFromSuperview];
    }
}

- (BOOL) string:(NSString *) bigString containsString:(NSString*) substring
{
    NSRange range = [bigString rangeOfString: substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)profileRefreshButtonPress:(id)sender {
    [self refreshProfile];
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
    
    /*
    if (self.profileItems) {
        return 1;
    }
    
    else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"You have not uploaded any photos (yet).";
        messageLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"System Italic" size:20];
        [messageLabel sizeToFit];
        
        self.collectionView.backgroundView = messageLabel;
    }
    
    return 0;
     */
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.profileItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCVCell *cell = (ProfileCVCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Profile Cell" forIndexPath:indexPath];
    
    // Configure the cell
    
    if (!cell) {
        cell = [[ProfileCVCell alloc]init];
    }

    /*cell.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                                    green:33.0f/255.0f
                                                     blue:36.0f/255.0f
                                                    alpha:1.0f];
     */
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.backgroundView.frame = cell.frame;
    //cell.backgroundView = cellView;
    cell.cvImage.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *PhotoUrlString = self.profileItems[indexPath.row][@"PhotoURL"];
    
    if ([self string:PhotoUrlString containsString:@"https://onedrive.live.com/redir?"]) {
        
        NSString *encString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)PhotoUrlString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
        
        
        //make request
        NSString *theUrlAsString = @"https://api.onedrive.com/v1.0/shares/";
        
        NSURL *firstURL = [NSURL URLWithString:theUrlAsString];
        
        NSURL *encURL = [firstURL URLByAppendingPathComponent:encString];
        NSURL *DwnldUrl = [encURL URLByAppendingPathComponent:@"/root/thumbnails/0/large/content"];
        PhotoUrlString = [DwnldUrl absoluteString];
        NSLog(@"Encoded partially with root: %@", PhotoUrlString);
    }

    
    [cell.cvImage setImageWithURL:[NSURL URLWithString: PhotoUrlString] placeholderImage:[UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"]];

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
    
    ProfileViewHeaderView *reusableHeader = nil;
    if ([kind isEqual:UICollectionElementKindSectionHeader] == YES) {
        reusableHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [reusableHeader sizeToFit];
    }
    
    NSString *nameString = [WelcomeViewController sharedController].userName;
    NSArray *firstLastName = [nameString componentsSeparatedByString:@"_"];
    
    reusableHeader.firstNameLabel.text = firstLastName[0];
    reusableHeader.lastNameLabel.text = firstLastName[1];
    reusableHeader.totalPostsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.profileItems.count];
    
    return reusableHeader;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.window.frame.size.width, 100.0f);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileEnlargedViewController *EnlargedViewManager = [[ProfileEnlargedViewController alloc] init];
    
    double distanceInt = [self.profileItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceUnit = @"miles";
    
    if (distanceInt < 1.0) {
        distanceUnit = @"feet";
        distanceInt = distanceInt * 5280;
        if (distanceInt < 2) {
            distanceUnit = @"foot";
            if (distanceInt < 0.5) {
                distanceUnit = @"feet";
            }
        }
    }
    
    NSString *distanceString = [NSString stringWithFormat:@"%.f %@", distanceInt, distanceUnit];
    
    ProfileCVCell *proCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    parameterDict[@"photo"] = proCell.cvImage.image;
    parameterDict[@"distanceString"] = distanceString;
    parameterDict[@"time"] = self.profileItems[indexPath.row][@"TimeStamp"];
    
    [EnlargedViewManager setUpEnlargedViewWithDict:parameterDict];
    
    //go to the enlarged view
    //[self performSegueWithIdentifier:@"segueToEnlarge" sender:self];
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

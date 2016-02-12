//
//  StreamPROCollectionViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamPROCollectionViewController.h"
#import "ProfileController.h"
#import "StreamPROCollectionViewCell.h"
#import "StreamPROCollectionHeaderView.h"
#import "StreamPROEnlargedViewController.h"
#import "NSNetworkConnection.h"
#import "UIImageView+AFNetworking.h"
#import "ImageCache.h"
#import "UIImageView+ImgViewCat.h"

@interface StreamPROCollectionViewController ()

//holds the items from the JSON Array
@property (strong, nonatomic) NSMutableArray *allProfileItems;
@end

@implementation StreamPROCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
NSString *UserID;
UILabel *internetFailLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileActivityIndicator.hidesWhenStopped = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self refreshStreamProfile];
}

- (void)refreshStreamProfile {
    NSNetworkConnection *NetworkManager = [[NSNetworkConnection alloc] init];
    
    if ([NetworkManager doesUserHaveInternetConnection]) {
    
        self.profileActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.profileActivityIndicator.color = [UIColor orangeColor];
        [self.profileActivityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = NO;
    
        // Register cell classes
        [self.collectionView registerClass:[StreamPROCollectionViewCell class]    forCellWithReuseIdentifier:reuseIdentifier];
    
        // Do any additional setup after loading the view.
        /*
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
        //[self.collectionView setCollectionViewLayout:flow];
    
        UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
    */
        //get the profile items (images)
        ProfileController *profileController = [[ProfileController alloc] init];
        [profileController requestProfileItemsFromUser:UserID AndIsCurrentUser:NO WithCompletion:^(NSMutableArray *Items, NSError *error) {
        
            if (!error) {
                self.allProfileItems = [Items mutableCopy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationItem setTitle:self.allProfileItems[0][@"UserName"]];
                    if ([self.profileActivityIndicator isAnimating] == YES) {
                        [self.profileActivityIndicator stopAnimating];
                    }
                    else {
                        //do nothing if for some reason the indicator was not animating
                    }
                    [self.collectionView reloadData];
                });

                //[self.collectionView reloadData];
            
                NSLog(@"Finished fetching profileItems");

                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            else {
                NSLog(@"Error getting profile items: %@", error);
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.profileActivityIndicator isAnimating] == YES) {
                        [self.profileActivityIndicator stopAnimating];
                    }});

            
                if (error.code == 3840) {
                    //user has 0 items in profile
                  
                }
            
                else {
                    UIAlertView *failedToGetProfileItems = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We were unable to retrieve your photos from the server. Please make sure that your device is connected to the internet and try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                    [self.profileActivityIndicator stopAnimating];
                    [failedToGetProfileItems show];
                }

                
            }
        
        }];
        }
    
    else {
        NSLog(@"NO CONNECTION");
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.profileActivityIndicator isAnimating] == YES) {
                [self.profileActivityIndicator stopAnimating];
            }});
        if ([internetFailLabel superview] == nil) {
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenW = screenRect.size.width;
            //CGFloat screenH = screenRect.size.height;
            
            //10,10,300,20
            internetFailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenW, 20)];

            //connectionFailLabel.center = CGPointMake(0.0f, 64.0f);
            [internetFailLabel setText:@"No Internet Connection"];
            [internetFailLabel setTextAlignment:NSTextAlignmentCenter];
            internetFailLabel.backgroundColor = [UIColor grayColor];
            internetFailLabel.textColor = [UIColor whiteColor];
            [self.collectionView addSubview:internetFailLabel];
            
            NSTimer *connectionFailViewTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
            
            [[NSRunLoop mainRunLoop] addTimer:connectionFailViewTimer forMode:NSDefaultRunLoopMode];
        }

    }
}

- (BOOL) string:(NSString *) bigString containsString:(NSString*) substring
{
    NSRange range = [bigString rangeOfString: substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (void)timerFireMethod:(NSTimer *)timer {
    if ([internetFailLabel superview] != nil) {
        [internetFailLabel removeFromSuperview];
    }
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
    
    StreamPROCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StreamPROCell" forIndexPath:indexPath];
    
    // Configure the cell
    if (!cell) {
        cell = [[StreamPROCollectionViewCell alloc] init];
    }
    
    //use "ThumbnailPhoto" or "LargePhoto"
    
    /*cell.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                           green:33.0f/255.0f
                                            blue:36.0f/255.0f
                                           alpha:1.0f]; */
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.backgroundView.frame = cell.frame;
    cell.proCVImage.contentMode = UIViewContentModeScaleAspectFill;
    
    
    NSString *PhotoUrlString = self.allProfileItems[indexPath.row][@"PhotoURL"];
    
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
        
        //set image
        [cell.proCVImage setImageWithURL:DwnldUrl    placeholderImage:[UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"]];
        
    }
    
    else if ([PhotoUrlString  isEqual: @"BLOB"]) {
        PhotoUrlString = [NSString stringWithFormat:@"https://whereaboutcloud.blob.core.windows.net/%@", self.allProfileItems[indexPath.row][@"PhotoID"]];
        
        if ([[ImageCache sharedImageCache] DoesExist:PhotoUrlString] == true)
        {
            cell.proCVImage.image = [[ImageCache sharedImageCache] GetImage:PhotoUrlString];
        }
        
        else
        {
            cell.proCVImage.image = [UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"];
            
            
            [cell.proCVImage downloadImageFromLink:PhotoUrlString andContentMode:UIViewContentModeScaleAspectFit withCompletionHandler:^{
                [[ImageCache sharedImageCache] AddImage:PhotoUrlString WithImage:cell.proCVImage.image];
            }];
            
        }
        
        NSLog(@"URL TO BLOB: %@", PhotoUrlString);
        
    }
    
    else {
        NSLog(@"URL WAS NEITHER BLOB NOR FROM ONEDRIVE SHARES");
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 100);
}

/*
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 2.0;
}
*/
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
    
    double distanceInt = [self.allProfileItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceUnit = @"miles";
    
    if (distanceInt < 2.0) {
        distanceUnit = @"mile";
    }
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
    StreamPROCollectionViewCell *streamProCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableDictionary *parameterDict = [[ NSMutableDictionary alloc] init];
    parameterDict[@"photo"] = streamProCell.proCVImage.image;
    parameterDict[@"distance"] = distanceString;
    parameterDict[@"time"] = self.allProfileItems[indexPath.row][@"TimeStamp"];
    parameterDict[@"Latitude"] = self.allProfileItems[indexPath.row][@"Latitude"];
    parameterDict[@"Longitude"] = self.allProfileItems[indexPath.row][@"Longitude"];
    
    StreamPROEnlargedViewController *EnlargedViewManager = [[StreamPROEnlargedViewController alloc] init];
    
    [EnlargedViewManager setUpEnlargedViewWithDict: parameterDict];
    
    //go to the enlarged view
    //[self performSegueWithIdentifier:@"segueEnlargedImage" sender:self];
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

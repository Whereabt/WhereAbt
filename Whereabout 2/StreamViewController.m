//
//  StreamViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 1/1/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamViewController.h"
#import "StreamController.h"
#import "EnlargeViewController.h"
#import "StreamEnlarge&SaveViewController.h"
#import "NSNetworkConnection.h"
#include <math.h>
#include <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
//#import <AFNetworking/AFNetworking.h>
#import <InstagramSimpleOAuth/InstagramSimpleOAuth.h>
#import "StreamTVCell.h"
#import "PhotosAccessViewController.h"
#import "MapVCViewController.h"
#import "ImageCache.h"
#import "UIImageView+ImgViewCat.h"

@interface StreamViewController ()

@property (strong, nonatomic) NSMutableArray *streamItems;
@property (assign, nonatomic) BOOL hasLoadedStream;

@end



@implementation StreamViewController

UILabel *connFailLabel;
UILabel *uploadLabel;
UIActivityIndicatorView *StreamActivityView;
bool isUploadingPhoto;
PhotosAccessViewController *photoVC;



- (void)viewDidLoad {
     [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    NSLog(@"screen width: %f AND height: %f", screenWidth, screenRect.size.height);
    
    self.tableActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.tableActivityIndicator.hidesWhenStopped = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStream) forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.hasLoadedStream == NO) {
        //[self refreshStream];
        [self refreshStream];
        
        self.hasLoadedStream = YES;
    }
    else {
        if (isUploadingPhoto) {
            [self startRefreshControlOnPhotoUpload];
        }
    }
}

- (void)refreshStream
{
    NSNetworkConnection *NetworkManager = [[NSNetworkConnection alloc] init];
    
    if ([NetworkManager doesUserHaveInternetConnection]) {
        NSLog(@"HAS CONNECTION");
        
        [self.tableView bringSubviewToFront:self.tableActivityIndicator];
        //[self.tableActivityIndicator startAnimating];
        
        UIActivityIndicatorView *StreamActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        NSLog(@"Point: %@", NSStringFromCGPoint(self.view.center));
        StreamActivityView.center = CGPointMake(self.view.window.center.x, self.view.window.center.y - (self.view.window.frame.size.height/2) + 20);
        
        [self.view addSubview:StreamActivityView];
        
        
        //[StreamActivityView startAnimating];
        
        if (![self.refreshControl isRefreshing]) {
            [self.refreshControl beginRefreshing];
        }
        
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        self.tableView.alwaysBounceVertical = YES;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //create object to deal with network requests
        StreamController *networkRequester = [[StreamController alloc] init];
        
        
        
        //USE f FOR RADIUS PARAM
        [networkRequester getFeedWithRadius:4000 andCompletion:^(NSMutableArray *items, NSError *error) {
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
                
                [self.tableView reloadData];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, h:mm a"];
                NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                self.refreshControl.attributedTitle = attributedTitle;
                
                [self.refreshControl endRefreshing];
                
                /*
                if ([self.tableActivityIndicator isAnimating] == YES) {
                    [self.tableActivityIndicator stopAnimating];
                }
                [StreamActivityView stopAnimating];
                [StreamActivityView removeFromSuperview];
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                 [self.collectionView reloadData];
                 });
                 */
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            }
            
            else{
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (error.code == 3840) {
                    [self.refreshControl endRefreshing];
                }
                
                else {
                    UIAlertView *streamFailAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"Sorry, we were unable to retrieve nearby photos from the server. Make sure that your device is connected to the internet and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                    [streamFailAlert show];
                }
            }
        }];
        
    }
    
    else {
        NSLog(@"NO CONNECTION");
        [self.refreshControl endRefreshing];
        if ([connFailLabel superview] == nil) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenW = screenRect.size.width;
            //CGFloat screenH = screenRect.size.height;
            
            //10,10,300,20
            connFailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenW, 20)];
            //connectionFailLabel.center = CGPointMake(0.0f, 64.0f);
            [connFailLabel setText:@"No Internet Connection"];
            [connFailLabel setTextAlignment:NSTextAlignmentCenter];
            connFailLabel.backgroundColor = [UIColor grayColor];
            connFailLabel.textColor = [UIColor whiteColor];
            [self.tableView addSubview:connFailLabel];
        
            NSTimer *connectionFailViewTimer = [NSTimer timerWithTimeInterval:3.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
            
            [[NSRunLoop mainRunLoop] addTimer:connectionFailViewTimer forMode:NSDefaultRunLoopMode];
        }
    }
    
}

- (void)setUploadingPhotoVarTo:(BOOL) boolean {
    isUploadingPhoto = boolean;
    if (!isUploadingPhoto) {
        if ([uploadLabel superview]) {
            [uploadLabel removeFromSuperview];
        }
    }
}


- (void)updateStream {
    StreamController *streamCont = [[StreamController alloc] init];
    [streamCont getFeedFromAzureCloudFileWithRadius:4000 andCompletion:^(NSMutableArray *items, NSError *error) {
        self.streamItems = items;
    }];
}

- (BOOL)uploadingPhoto{
    
    return isUploadingPhoto;
}

- (void)startRefreshControlOnPhotoUpload {
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    
    NSString *title = @"Uploading photo";
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;

    if ([uploadLabel superview] == nil) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenRect.size.width, 20)];
        [uploadLabel setText:@"Uploading..."];
        
        [uploadLabel setTextAlignment:NSTextAlignmentCenter];
        uploadLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        
        uploadLabel.textColor = [UIColor whiteColor];
        [self.tableView addSubview:uploadLabel];
    }
}

- (BOOL) string:(NSString *) bigString containsString:(NSString*) substring
{
    NSRange range = [bigString rangeOfString: substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (void)stopRefreshControlOnPhotoUpload {

    if ([uploadLabel superview] != nil) {
        [uploadLabel performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
    
    [self setUploadingPhotoVarTo:NO];
}

- (void)timerFireMethod:(NSTimer *)timer {
    if ([connFailLabel superview] != nil) {
        [connFailLabel removeFromSuperview];
    }
}


- (IBAction)savedPhotoAlbumButtonCalled:(id)sender {
    PhotosAccessViewController *photoController = [[PhotosAccessViewController alloc] init];
    [photoController setSourceTypeToWantsCamera:NO];
    //[self presentViewController:photoController animated:YES completion:nil];
}

- (IBAction)cameraButtonCalled:(id)sender {
    /*
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)) {
        photoVC = [[PhotosAccessViewController alloc] init];
        [photoVC setSourceTypeToWantsCamera:YES];
        [self presentViewController:photoVC animated:YES completion:nil];
    }
    else {
        UIAlertView *noCameraAlert = [[UIAlertView alloc]initWithTitle:@"Problem Occurred" message:@"It appears that your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noCameraAlert show];
    }
     */
    
    [self performSegueWithIdentifier:@"segueToImageCapture" sender:self];
}

- (void)closePhotoVCWithCompletion:(void (^)(void))completionBlock {
    [photoVC dismissViewControllerAnimated:YES completion:^{
        completionBlock();
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

                                  
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.streamItems) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    
    else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"No photos are currently available from your vicinity. Please pull down to refresh.";
        messageLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"System Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.streamItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
     StreamTVCell *cell = (StreamTVCell*)[tableView dequeueReusableCellWithIdentifier:@"User ID" forIndexPath:indexPath];
    
    /*
    cell.cellDistance.text = distanceString;
    cell.cellDistance.font = [UIFont fontWithName: @"System" size:8];
    cell.cellDistance.numberOfLines = 1;
    cell.cellDistance.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    cell.cellDistance.adjustsFontSizeToFitWidth = YES;
    cell.cellDistance.textAlignment = NSTextAlignmentCenter;
    cell.cellDistance.textColor = [UIColor colorWithRed:56.0f/255.0f green:171.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    */
    
    cell.cellImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
        NSString *PhotoUrlString = self.streamItems[indexPath.row][@"PhotoURL"];
    
        if ([self string:PhotoUrlString containsString:@"https://onedrive.live.com/redir?"]) {
        
            NSString *encString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)PhotoUrlString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
            if ([self.streamItems[indexPath.row][@"TimeStamp"]  isEqual: @"2016-02-18T22:57:06"]) {
                //nothing
            }
        
            //make request
            NSString *theUrlAsString = @"https://api.onedrive.com/v1.0/shares/";
        
            NSURL *firstURL = [NSURL URLWithString:theUrlAsString];
        
            NSURL *encURL = [firstURL URLByAppendingPathComponent:encString];
            NSURL *DwnldUrl = [encURL URLByAppendingPathComponent:@"/root/thumbnails/0/large/content"];
            
            //set image
            [cell.cellImage setImageWithURL:DwnldUrl    placeholderImage:[UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"]];

        }
    /*
    https://onedrive.live.com/redir?resid=97F18E29597D2251!1123&authkey=!ALhELhz6Lk5tw6s
    https://onedrive.live.com/redir?resid=61F9F6D60F0FE04B!252&authkey=!AOXbMIA_bBLXw4o */
    
        else if ([PhotoUrlString  isEqual: @"BLOB"]) {
            PhotoUrlString = [NSString stringWithFormat:@"https://whereaboutcloud.blob.core.windows.net/%@", self.streamItems[indexPath.row][@"PhotoID"]];
            
            if ([[ImageCache sharedImageCache] DoesExist:PhotoUrlString] == true)
            {
                cell.cellImage.image = [[ImageCache sharedImageCache] GetImage:PhotoUrlString];
            }
            
            else
            {
                cell.cellImage.image = [UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"];
                
                
                [cell.cellImage downloadImageFromLink:PhotoUrlString andContentMode:UIViewContentModeScaleAspectFit withCompletionHandler:^{
                    NSLog(@"IMAGE HEIGHT:%f", cell.cellImage.frame.size.height);
                    [[ImageCache sharedImageCache] AddImage:PhotoUrlString WithImage:cell.cellImage.image];
                }];
                
            }
            
            //NSLog(@"URL TO BLOB: %@", PhotoUrlString);
            
        }
    
        else {
            NSLog(@"URL WAS NEITHER BLOB NOR FROM ONEDRIVE SHARES");
        }

    
        cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *dictionaryParameter = [[NSMutableDictionary alloc] initWithDictionary:self.streamItems[indexPath.row]];
    
    StreamTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    double distanceInt = [self.streamItems[indexPath.row][@"MilesAway"] doubleValue];
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
    
    if ([distanceString  isEqual: @"1 miles"]) {
        distanceString = @"1 mile";
    }

    [dictionaryParameter setObject:distanceString forKey:@"Distance"];
    [dictionaryParameter setObject:cell.cellImage.image forKey:@"Photo"];
    
    StreamEnlarge_SaveViewController *SaveController = [[StreamEnlarge_SaveViewController alloc] init];
    [SaveController setUpTheEnlargedViewWithItemDictionary:dictionaryParameter];
    
    MapVCViewController *mapVC = [[MapVCViewController alloc] init];
    [mapVC setUpMapViewWithDictionary:dictionaryParameter];
    
    //[self performSegueWithIdentifier:@"segueToEnlargeSave" sender:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.streamItems[indexPath.row][@"ThumbnailURL"]  isEqual: @"UNAVAILABLE"]) {
        return [self.streamItems[indexPath.row][@"ThumbnailURL"] floatValue];
    }
    else {
        return 273;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
     

@end

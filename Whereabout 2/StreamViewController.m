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
#import "StreamTVCell.h"

@interface StreamViewController ()


@property (strong, nonatomic) NSMutableArray *streamItems;

@end



@implementation StreamViewController
UILabel *connFailLabel;

- (void)viewDidLoad {
     [super viewDidLoad];
    
    self.tableActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.tableActivityIndicator.hidesWhenStopped = YES;
    [self refreshStream];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refreshStream
{
    NSNetworkConnection *NetworkManager = [[NSNetworkConnection alloc] init];
    
    if ([NetworkManager doesUserHaveInternetConnection]) {
        NSLog(@"HAS CONNECTION");
        
        [self.tableView bringSubviewToFront:self.tableActivityIndicator];
        [self.tableActivityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        self.tableView.alwaysBounceVertical = YES;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
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
        
        //USE f FOR RADIUS PARAM
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
                
                [self.tableView reloadData];
                if ([self.tableActivityIndicator isAnimating] == YES) {
                    [self.tableActivityIndicator stopAnimating];
                }
                
                /*
                 dispatch_async(dispatch_get_main_queue(), ^{
                 [self.collectionView reloadData];
                 });
                 */
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            }
            
            else{
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                NSLog(@"Error getting streamItems: %@", error);
                [self.tableActivityIndicator stopAnimating];
                
                if (error.code == 3840) {
                    UIView *NoFeedView = [[UIView alloc] initWithFrame:self.tableView.frame];
                    
                    UILabel *nothingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, 50)];
                    nothingLabel.text = @"No images from your vicinity";
                    nothingLabel.textColor = [UIColor colorWithRed:31.0f/255.0f
                                                             green:33.0f/255.0f
                                                              blue:36.0f/255.0f
                                                             alpha:1.0f];
                    
                    UILabel *suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 35)];
                    suggestLabel.text = @"We suggest increasing your radius in settings";
                    suggestLabel.textColor = [UIColor blackColor];
                    
                    [NoFeedView addSubview:nothingLabel];
                    [NoFeedView addSubview:nothingLabel];
                    
                    [self.view addSubview:NoFeedView];
                    
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
        
        if ([connFailLabel superview] == nil) {
            connFailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
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

- (void)timerFireMethod:(NSTimer *)timer {
    if ([connFailLabel superview] != nil) {
        [connFailLabel removeFromSuperview];
    }
}

- (IBAction)refreshButtonCall:(id)sender {
    [self refreshStream];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

                                  
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.streamItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
     StreamTVCell *cell = (StreamTVCell*)[tableView dequeueReusableCellWithIdentifier:@"User ID" forIndexPath:indexPath];
    
    double distanceInt = [self.streamItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceString = [NSString stringWithFormat:@"%.3f Miles ", distanceInt];
    cell.cellDistance.text = distanceString;
    cell.cellDistance.font = [UIFont fontWithName: @"Arial Rounded MT Bold" size:14];
    cell.cellDistance.numberOfLines = 1;
    cell.cellDistance.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    cell.cellDistance.adjustsFontSizeToFitWidth = YES;
    cell.cellDistance.textAlignment = NSTextAlignmentLeft;
    cell.cellDistance.textColor = [UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    
    cell.cellImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [cell.cellImage setImageWithURL:[NSURL URLWithString:self.streamItems[indexPath.row][@"PhotoURL"]] placeholderImage:[UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"]];
    
    /*
    [cell.cellImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.streamItems[indexPath.row][@"PhotoURL"]]] placeholderImage:[UIImage imageNamed:@"Gray Stream Placeholder Image.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //success
        self.streamItems[indexPath.row][@"PHOTO"] = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //failure
        self.streamItems[indexPath.row][@"PHOTO"] = @"None";
    }];
    */
    
    cell.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                           green:33.0f/255.0f
                                            blue:36.0f/255.0f
                                           alpha:1.0f];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *dictionaryParameter = [[NSMutableDictionary alloc] init];
    
    double distanceInt = [self.streamItems[indexPath.row][@"MilesAway"] doubleValue];
    NSString *distanceAwayString = [NSString stringWithFormat:@"%.3f", distanceInt];
    
    StreamTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell distance: %@", cell.cellDistance.text);
    
    [dictionaryParameter setObject:distanceAwayString forKey:@"Distance"];
    [dictionaryParameter setObject:cell.cellImage.image forKey:@"Photo"];
    [dictionaryParameter setObject:self.streamItems[indexPath.row][@"UserID"] forKey:@"ID"];
    [dictionaryParameter setObject:self.streamItems[indexPath.row][@"UserName"] forKey:@"Name"];
    [dictionaryParameter setObject:self.streamItems[indexPath.row][@"TimeStamp"] forKey:@"Time"];
    
    StreamEnlarge_SaveViewController *SaveController = [[StreamEnlarge_SaveViewController alloc] init];
    [SaveController setUpTheEnlargedViewWithItemDictionary:dictionaryParameter];
    
    //[self performSegueWithIdentifier:@"segueToEnlargeSave" sender:self];
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

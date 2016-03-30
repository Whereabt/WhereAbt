//
//  StreamEnlarge&SaveViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/29/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamEnlarge&SaveViewController.h"
#import "StreamPROCollectionViewController.h"
#import "WelcomeViewController.h"
#import "LocationController.h"
#import "MapVCViewController.h"
#import <OneDriveSDK/OneDriveSDK.h>
#import "ReportViewController.h"
#import <JNKeychain/JNKeychain.h>
#import <Google/Analytics.h>

@interface StreamEnlarge_SaveViewController ()

@end

@implementation StreamEnlarge_SaveViewController

NSMutableDictionary *UIimageDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *nameArray = [UIimageDict[@"UserName"] componentsSeparatedByString:@"_"];
    
    NSString *nameString = [NSString stringWithFormat:@"%@ %@", nameArray[0], nameArray[1]];
    [self.nameButton setTitle:nameString forState:UIControlStateNormal];
    [self.nameButton.titleLabel adjustsFontSizeToFitWidth];
    self.theImageView.image = UIimageDict[@"Photo"];
    self.theImageView.userInteractionEnabled = YES;
    self.theImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.locationButton.titleLabel.adjustsFontSizeToFitWidth = NO;
    self.locationButton.titleLabel.text = UIimageDict[@"Distance"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *imageDate = [dateFormatter dateFromString: UIimageDict[@"TimeStamp"]];
    
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSinceDate: imageDate];
    double hrs = (interval/3600);
    double days = (hrs/24);         
    
    //show days if more than one, if not show hrs
    double t;
    NSString *labelString = [[NSString alloc] init];
    
    if (interval < 60) {
        labelString = [NSString stringWithFormat: @"%.0f seconds ago", interval];
    }
    else {
    
        if (days <= 1) {
            if (hrs < 1) {
                t = round(interval/60);
                NSString *minCheckString = [NSString stringWithFormat:@"%.0f minutes ago", t];
                
                if ([minCheckString isEqualToString:@"1 minutes ago"]) {
                    labelString = @"1 minute ago";
                }
                else {
                    labelString = minCheckString;
                }
            }
            else {
                t = round(hrs);
                NSString *hrcheckString = [NSString stringWithFormat:@"%.0f hours ago", t];
                
                if ([hrcheckString isEqualToString:@"1 hours ago"]) {
                    labelString = @"1 hour ago";
                }
                else {
                    labelString = hrcheckString;
                }
            }
        
        }
        else if (days >= 365) {
            t = round(days / 365);
            NSString *yrCheckString = [NSString stringWithFormat:@"%.0f years ago", t];
            if ([yrCheckString isEqualToString:@"1 years ago"]) {
                labelString = @"1 year ago";
            }
            else {
                labelString = yrCheckString;
                
            }
        }
    
        else {
            t = round(days);
            NSString *daysString = [NSString stringWithFormat:@"%.0f", t];
        
            if ([daysString  isEqual: @"1"]) {
                labelString = @"1 day ago";
            }
        
            else {
                labelString = [NSString stringWithFormat:@"%@ days ago", daysString];
            }

      }
        /*CLLocation *location = [[CLLocation alloc] initWithLatitude:[UIimageDict[@"Latitude"] doubleValue] longitude:[UIimageDict[@"Longitude"] doubleValue]];
        
        LocationController *locationCont = [[LocationController alloc] init];
        
        [locationCont getNameFromLocation:location isNear:YES AndCompletion:^(NSString *locationName) {
            NSLog(@"%@", locationName);
            NSString *updatedLabelString = [NSString stringWithFormat: @"%@, %@", locationName, UIimageDict[@"Distance"]];
            
            [self.locationButton.titleLabel setText:updatedLabelString];
            
            MapVCViewController *mapController = [[MapVCViewController alloc] init];
            [mapController setUpMapViewWithLocation:location];
        }];
         */
  }
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    NSLog(@"Label string: %@", labelString);
    self.timeLabel.text = labelString;
    
    ReportViewController *reportVC = [[ReportViewController alloc]init];
    [reportVC getPhotoIdToReportVC:UIimageDict[@"PhotoID"]];
}


-(void)viewWillAppear:(BOOL)animated {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Stream Enlarge VC"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.locationButton.titleLabel.text  isEqual: @"Location"]) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[UIimageDict[@"Latitude"] doubleValue] longitude:[UIimageDict[@"Longitude"] doubleValue]];
        
        LocationController *locationCont = [[LocationController alloc] init];
        
        [locationCont getNameFromLocation:location isNear:YES AndCompletion:^(NSString *locationName) {
            NSLog(@"%@", locationName);
            NSString *updatedLabelString = [NSString stringWithFormat: @"%@, %@", locationName, UIimageDict[@"Distance"]];
            [self.locationButton setTitle:updatedLabelString forState:UIControlStateNormal];
            [self.locationButton setNeedsLayout];
            
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)getBackgroundColor {
    return self.view.backgroundColor;
}

- (void)setUpTheEnlargedViewWithItemDictionary:(NSMutableDictionary *)imageItem {
    UIimageDict = imageItem;
}

- (IBAction)nameButtonPressed:(id)sender {
    StreamPROCollectionViewController *StreamPROController = [[StreamPROCollectionViewController alloc] init];
    [StreamPROController setUpProfileWithUserID:UIimageDict[@"UserID"]];
    //[self performSegueWithIdentifier:@"segueToProfile" sender:self];
}

- (IBAction)longButtonPress:(id)sender {
    
    //create the alert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //action for save
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Camera Roll", "Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImageWriteToSavedPhotosAlbum(self.theImageView.image, nil, nil, nil);
        if (self.presentingViewController == alertController) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:yesAction];
    
    if ([[JNKeychain loadValueForKey:@"AuthenticationMethod"] isEqual: @"OneDriveAuthentication"])
    {
        UIAlertAction *odSaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Private OneDrive", "OneDrive Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSData *dataFromImage = UIImagePNGRepresentation(self.theImageView.image);
        
        //unique name for onedrive file
        NSString *processedName = [[NSProcessInfo processInfo]globallyUniqueString];
        NSString *uniqueFileName = [NSString stringWithFormat:@"%@.jpg", processedName];

            //request
            NSString *path = [NSString stringWithFormat:@"Whereabout_Private/%@", uniqueFileName];
            ODClient *odclient = [ODClient loadCurrentClient];
        
            ODItemContentRequest *Request = [[[odclient root] itemByPath:path] contentRequest];
            
            [Request uploadFromData:dataFromImage completion:^(ODItem *response, NSError *error) {
                
                NSLog(@"RESPONSE FROM UPLOAD: %@", response);
                if (error) {
                    NSLog(@"Error uploading: %@", error);
                }
                
                else {
                    //all good
                    NSLog(@"Success on private upload");
                }
            }];

        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        }];

    
        [alertController addAction: odSaveAction];
    }
    
    //cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", "Cancel Action") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (self.presentingViewController == alertController) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:cancelAction];
    
    //finally present the alert
    [self presentViewController:alertController animated:YES completion:nil];
    
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

//
//  ProfileEnlargedViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ProfileEnlargedViewController.h"
#import "WelcomeViewController.h"
#import "LocationController.h"
#import "ProfileController.h"
#import <OneDriveSDK/OneDriveSDK.h>
#import "ProfileCollectionViewController.h"

@interface ProfileEnlargedViewController ()

@end

@implementation ProfileEnlargedViewController

NSDictionary *itemDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@", itemDict[@"distanceString"]];
    self.largeImageView.image = itemDict[@"photo"];
    self.largeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.largeImageView.userInteractionEnabled = YES;
    self.largeImageView.frame = self.view.window.frame;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *imageDate = [dateFormatter dateFromString: itemDict[@"time"]];
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
        
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[itemDict[@"Latitude"] doubleValue] longitude:[itemDict[@"Longitude"] doubleValue]];
    
    LocationController *locationCont = [[LocationController alloc] init];
    
    [locationCont getNameFromLocation:location isNear:NO AndCompletion:^(NSString *locationName) {
        NSLog(@"%@", locationName);
        NSString *updatedLabelString = [NSString stringWithFormat: @"%@, %@", locationName, itemDict[@"distanceString"]];
        self.distanceLabel.adjustsFontSizeToFitWidth = YES;
        [self.distanceLabel setText:updatedLabelString];
    }];

    self.timeIntervalLabel.adjustsFontSizeToFitWidth = YES;
    self.timeIntervalLabel.text = labelString;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)longPressGesture:(id)sender {
    //create the alert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"What would you like to do with this photo?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //action for delete
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete from Whereabout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //start indicator
        [self.activityIndicatorView startAnimating];
        //make request
        ProfileController *profileController = [[ProfileController alloc] init];
        [profileController deletePhotoFromDBWithPhotoID:itemDict[@"PhotoID"] andCompletion:^(NSError *completionError) {
            //stop indicator
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicatorView stopAnimating];
            });

            if (completionError) {
                NSLog(@"Error in deleting photo:%@", completionError);
                //create alert cont
                UIAlertController *completionAlertCont = [UIAlertController alertControllerWithTitle:@"Error Deleting Photo" message:@"We ran into an error deleting your photo, please try again later." preferredStyle:UIAlertControllerStyleAlert];
                
                //create ok action
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //completion
                    [completionAlertCont dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                //add action
                [completionAlertCont addAction:okAction];
            }
            
            else {
                NSLog(@"Successfully deleted photo from db");
                ProfileCollectionViewController *profileCollVC = [[ProfileCollectionViewController alloc] init];
                [profileCollVC deleteEntryFromProfileItemsWithIndex:itemDict[@"Index"]];
            }
        }];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:deleteAction];
    
    //action for save
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Camera Roll", "Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImageWriteToSavedPhotosAlbum(self.largeImageView.image, nil, nil, nil);
        if (self.presentingViewController == alertController) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:yesAction];
    
    UIAlertAction *odSaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Private OneDrive", "OneDrive Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSData *dataFromImage = UIImagePNGRepresentation(self.largeImageView.image);
        
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

- (void)uploadToPrivateOneDriveAndCompletion:(void (^)(void))callBack {
    //image data for session
    NSData *dataFromImage = UIImagePNGRepresentation(self.largeImageView.image);
    
    //unique name for onedrive file
    NSString *processedName = [[NSProcessInfo processInfo]globallyUniqueString];
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@.jpg", processedName];
    
    //create session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //saving to 'Whereabout_Private' onedrive folder
    NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/root:/Whereabout_Private/%@:/content", uniqueFileName];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    //referencing auth singleton
    [request addValue:[NSString stringWithFormat:@"Bearer %@", [WelcomeViewController sharedController].authToken] forHTTPHeaderField: @"Authorization"];
    NSLog(@"UPLOAD_TOKEN: %@", [WelcomeViewController sharedController].authToken);
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:dataFromImage completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
        
        if (error) {
            UIAlertView *putToODFail = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We were unable to save this photo to your OneDrive, try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [putToODFail show];
        }
        
        else {
            NSLog(@"Succesfully saved image to the user's OneDrive");
        }
        
        callBack();
    }];
    
    [uploadTask resume];

}

- (void)setUpEnlargedViewWithDict:(NSDictionary *)enlargeDict
{
    itemDict = [[NSDictionary alloc] initWithDictionary:enlargeDict copyItems:YES];
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

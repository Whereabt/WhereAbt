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

@interface StreamEnlarge_SaveViewController ()

@end

@implementation StreamEnlarge_SaveViewController

NSMutableDictionary *UIimageDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *nameArray = [UIimageDict[@"Name"] componentsSeparatedByString:@"_"];
    
    NSString *nameString = [NSString stringWithFormat:@"%@ %@", nameArray[0], nameArray[1]];
    [self.nameButton setTitle:nameString forState:UIControlStateNormal];
    self.theImageView.image = UIimageDict[@"Photo"];
    self.theImageView.userInteractionEnabled = YES;
    self.theImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
    self.distanceLabel.text = UIimageDict[@"Distance"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *imageDate = [dateFormatter dateFromString: UIimageDict[@"Time"]];
    
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
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    NSLog(@"Label string: %@", labelString);
    self.timeLabel.text = labelString;
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
    [StreamPROController setUpProfileWithUserID:UIimageDict[@"ID"]];
    //[self performSegueWithIdentifier:@"segueToProfile" sender:self];
}

- (IBAction)longButtonPress:(id)sender {
    
    //create the alert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Image" message:@"Where would you like to save this image?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //action for save
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Camera Roll", "Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImageWriteToSavedPhotosAlbum(self.theImageView.image, nil, nil, nil);
        if (self.presentingViewController == alertController) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:yesAction];
    
    UIAlertAction *odSaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Private OneDrive", "OneDrive Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //check last token refresh and update if needed
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        NSDate *lastUpdate = [preferences objectForKey:@"Last token refresh"];
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastUpdate];
        if (lastUpdate == nil || interval > 3000) {
            
            WelcomeViewController *welcomeManager = [[WelcomeViewController alloc] init];
            [welcomeManager refreshAuthTokenWithCompletion:^{
                [self uploadToPrivateOneDriveAndCompletion:^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
        }
        
        else {
            [self uploadToPrivateOneDriveAndCompletion:^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        
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
    NSData *dataFromImage = UIImagePNGRepresentation(self.theImageView.image);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

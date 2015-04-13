//
//  ProfileEnlargedViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ProfileEnlargedViewController.h"
#import "WelcomeViewController.h"

@interface ProfileEnlargedViewController ()

@end

@implementation ProfileEnlargedViewController

NSString *DistanceAway;
UIImage *LargeImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ Miles", DistanceAway];
    self.largeImageView.image = LargeImage;
    self.largeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.largeImageView.frame = self.view.window.frame;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)longPressGesture:(id)sender {
    //create the alert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save Image" message:@"Where would you like to save this image?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //action for save
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Camera Roll", "Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImageWriteToSavedPhotosAlbum(self.largeImageView.image, nil, nil, nil);
        if (self.presentingViewController == alertController) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:yesAction];
    
    UIAlertAction *odSaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Save to Private OneDrive", "OneDrive Save Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
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
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [uploadTask resume];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction: odSaveAction];
    
    //cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", "Cancel Action") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (self.presentingViewController == alertController) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:cancelAction];
    
    //finally present the alert
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)setUpEnlargedViewWithDistance:(NSString *) distanceString andPhoto:(UIImage *)photo
{
    LargeImage = photo;
    DistanceAway = distanceString;
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

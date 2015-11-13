//
//  ReportViewController.m
//  Whereabout 2
//
//  Created by Casa on 11/7/15.
//  Copyright © 2015 Nicolas Isaza. All rights reserved.
//

#import "ReportViewController.h"
#import "StreamController.h"
#import "WelcomeViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

NSString *photoID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidesWhenStopped =YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getPhotoIdToReportVC: (NSString *)photoId {
    photoID = photoId;
}

- (IBAction)dontLikePress:(id)sender {
    [self.doesntBelongButton setEnabled:NO];
    [self.dontLikeButton setEnabled:NO];
    [self.riskButton setEnabled:NO];
    [self.scameSpamButton setEnabled:NO];
    
    
    [self.activityIndicator startAnimating];
    StreamController *streamController = [[StreamController alloc] init];
    [streamController reportPhotoWithUserID:[WelcomeViewController sharedController].userID andPhotoID:photoID andReason:@"A" withCompletion:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
        });

        
        if (error) {
            NSLog(@"Error in reporting photo: %@", error);
            //create alert cont
            UIAlertController *reportAlertCont = [UIAlertController alertControllerWithTitle:@"Error Reporting Photo" message:@"We ran into an error reporting this photo, please try again later." preferredStyle:UIAlertControllerStyleAlert];
            
            //create ok action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //completion
                [reportAlertCont dismissViewControllerAnimated:YES completion:nil];
                
            }];
            //add action
            [reportAlertCont addAction:okAction];
            [self presentViewController:reportAlertCont animated:YES completion:nil];
        }
        
        else {
            //nothing needs to happen at this point
        }
        
        [self.doesntBelongButton setEnabled:YES];
        [self.dontLikeButton setEnabled:YES];
        [self.riskButton setEnabled:YES];
        [self.scameSpamButton setEnabled:YES];
        
    }];
}

- (IBAction)scamSpamPress:(id)sender {
    [self.doesntBelongButton setEnabled:NO];
    [self.dontLikeButton setEnabled:NO];
    [self.riskButton setEnabled:NO];
    [self.scameSpamButton setEnabled:NO];
    
    
    [self.activityIndicator startAnimating];
    StreamController *streamController = [[StreamController alloc] init];
    [streamController reportPhotoWithUserID:[WelcomeViewController sharedController].userID andPhotoID:photoID andReason:@"B" withCompletion:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
        if (error) {
            NSLog(@"Error in reporting photo: %@", error);
            //create alert cont
            UIAlertController *reportAlertCont = [UIAlertController alertControllerWithTitle:@"Error Reporting Photo" message:@"We ran into an error reporting this photo, please try again later." preferredStyle:UIAlertControllerStyleAlert];
            
            //create ok action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //completion
                [reportAlertCont dismissViewControllerAnimated:YES completion:nil];
                
            }];
            //add action
            [reportAlertCont addAction:okAction];
            [self presentViewController:reportAlertCont animated:YES completion:nil];
        }
        
        else {
            //nothing needs to happen at this point
        }
        
        [self.doesntBelongButton setEnabled:YES];
        [self.dontLikeButton setEnabled:YES];
        [self.riskButton setEnabled:YES];
        [self.scameSpamButton setEnabled:YES];
        
    }];
}

- (IBAction)riskPress:(id)sender {
    [self.doesntBelongButton setEnabled:NO];
    [self.dontLikeButton setEnabled:NO];
    [self.riskButton setEnabled:NO];
    [self.scameSpamButton setEnabled:NO];
    
    
    [self.activityIndicator startAnimating];
    StreamController *streamController = [[StreamController alloc] init];
    [streamController reportPhotoWithUserID:[WelcomeViewController sharedController].userID andPhotoID:photoID andReason:@"C" withCompletion:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
        if (error) {
            NSLog(@"Error in reporting photo: %@", error);
            //create alert cont
            UIAlertController *reportAlertCont = [UIAlertController alertControllerWithTitle:@"Error Reporting Photo" message:@"We ran into an error reporting this photo, please try again later." preferredStyle:UIAlertControllerStyleAlert];
            
            //create ok action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //completion
                [reportAlertCont dismissViewControllerAnimated:YES completion:nil];
                
            }];
            //add action
            [reportAlertCont addAction:okAction];
            [self presentViewController:reportAlertCont animated:YES completion:nil];
        }
        
        else {
            //nothing needs to happen at this point
        }
        
        [self.doesntBelongButton setEnabled:YES];
        [self.dontLikeButton setEnabled:YES];
        [self.riskButton setEnabled:YES];
        [self.scameSpamButton setEnabled:YES];
        
    }];
}

- (IBAction)doesntBelongPress:(id)sender {
    [self.doesntBelongButton setEnabled:NO];
    [self.dontLikeButton setEnabled:NO];
    [self.riskButton setEnabled:NO];
    [self.scameSpamButton setEnabled:NO];
    
    
    [self.activityIndicator startAnimating];
    StreamController *streamController = [[StreamController alloc] init];
    [streamController reportPhotoWithUserID:[WelcomeViewController sharedController].userID andPhotoID:photoID andReason:@"D" withCompletion:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
        if (error) {
            NSLog(@"Error in reporting photo: %@", error);
            //create alert cont
            UIAlertController *reportAlertCont = [UIAlertController alertControllerWithTitle:@"Error Reporting Photo" message:@"We ran into an error reporting this photo, please try again later." preferredStyle:UIAlertControllerStyleAlert];
            
            //create ok action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //completion
                [reportAlertCont dismissViewControllerAnimated:YES completion:nil];
                
            }];
            //add action
            [reportAlertCont addAction:okAction];
            [self presentViewController:reportAlertCont animated:YES completion:nil];
        }
        
        else {
            //nothing needs to happen at this point
        }
        
        [self.doesntBelongButton setEnabled:YES];
        [self.dontLikeButton setEnabled:YES];
        [self.riskButton setEnabled:YES];
        [self.scameSpamButton setEnabled:YES];
        
    }];
}

@end

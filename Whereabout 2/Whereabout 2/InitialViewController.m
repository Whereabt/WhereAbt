//
//  InitialViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/3/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "InitialViewController.h"
#import "WelcomeViewController.h"
#import "KeychainItemWrapper.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (void)viewDidAppear:(BOOL)animated {
    WelcomeViewController *welcomeController = [[WelcomeViewController alloc] init];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
    
    [WelcomeViewController sharedController].refreshToken = nil;
    
    //[keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
    //check for stored refresh token
    if ([[keychain objectForKey:(__bridge id)(kSecValueData)] length] > 1) {
        
        //refresh the access token
        [WelcomeViewController sharedController].refreshToken = [keychain objectForKey:(__bridge id)(kSecValueData)];
        
        NSLog(@"Refresh token property value before refresh called: %@", [WelcomeViewController sharedController].refreshToken);
        
        [welcomeController refreshAuthTokenWithCompletion:^{
            //problem occurred while trying to get profile properties
            if ([WelcomeViewController sharedController].userID == nil) {
                UIAlertController *profilePropFail = [UIAlertController alertControllerWithTitle:@"Problem Occurred" message:@"We encountered an error while trying to retrieve your profile from the server. Please check your internet connection." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [profilePropFail dismissViewControllerAnimated:YES completion:nil];
                [self performSegueWithIdentifier:@"segueToLogin" sender:self];
                }];
                
                [profilePropFail addAction:okAction];
                [self presentViewController:profilePropFail animated:YES completion:nil];
            }
            
            //all good
            else {
            //[self performSegueWithIdentifier:@"segueToMain" sender:self];
                [self performSegueWithIdentifier:@"fakeSegue" sender:self];
            }
        }];
        //[self setAuthTokenRefreshTokenAndProfileNamesFromCode:[keychain objectForKey:(__bridge id)(kSecValueData)]];
    }
    
    else {
        
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        //DELETE
        //[preferences setBool:NO forKey:@"Done Walkthrough"];
        
        if ([preferences boolForKey:@"Done Walkthrough"] == NO) {
            [self performSegueWithIdentifier:@"segueToWalkthrough" sender:self];
            [preferences setBool:YES forKey:@"Done Walkthrough"];
        }
        
        else {
            //already done walkthrough
            [self performSegueWithIdentifier:@"segueToLogin" sender:self];
            
        }
    }
    
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

@end

//
//  InitialViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/3/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "InitialViewController.h"
#import "WelcomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationController.h"
#import <OneDriveSDK/OneDriveSDK.h>
#import "ProfileController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <JNKeychain/JNKeychain.h>
#import <InstagramSimpleOAuth/InstagramSimpleOAuth.h>

NSString *const InstagramCons = @"InstagramAuthentication";
NSString *const GoogleCons = @"GoogleAuthentication";
NSString *const OneDriveCons = @"OneDriveAuthentication";

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [LocationController sharedController];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    //[standardDefaults setBool:NO forKey:@"has launched"];
    if (![standardDefaults boolForKey:@"has launched"]) {
        [self performSegueWithIdentifier:@"segueToWalkthrough" sender:self];
        [standardDefaults  setBool:YES forKey:@"has launched"];
    }
    else {
        //DELETE
        //[JNKeychain deleteValueForKey:@"AuthenticationMethod"];
        NSLog(@"AUTHENTICATION: %@", [JNKeychain loadValueForKey:@"AuthenticationMethod"]);

        if ([[JNKeychain loadValueForKey:@"AuthenticationMethod"]  isEqual: GoogleCons] && [standardDefaults objectForKey:@"UserID"]) {
            NSLog(@"stored USERID: %@", [standardDefaults objectForKey:@"UserID"]);
            [GIDSignIn sharedInstance].clientID = [standardDefaults objectForKey:@"UserID"];
            [[GIDSignIn sharedInstance] signInSilently];
            [self performSegueWithIdentifier:@"fakeSegue" sender:self];
        }
        
        else if ([[JNKeychain loadValueForKey:@"AuthenticationMethod"]  isEqual: InstagramCons] && [standardDefaults objectForKey:@"UserID"]) {
            [self performSegueWithIdentifier:@"fakeSegue" sender:self];
        }
        
        else if ([[JNKeychain loadValueForKey:@"AuthenticationMethod"]  isEqual: OneDriveCons]) {
            NSArray *scopeArray = [[NSArray alloc] initWithObjects:@"wl.offline_access", @"onedrive.readwrite", nil];
            [ODClient setMicrosoftAccountAppId:@"000000004C13496E" scopes:scopeArray];
            [ODClient clientWithCompletion:^(ODClient *client, NSError *error){
                if (!error){
                    NSLog(@"Account ID: %@", client.accountId);
                    [[[[ODClient loadCurrentClient] drive] request] getWithCompletion:^(ODDrive *response, NSError *error) {
                        if (error) {
                            UIAlertView *usernameAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Please check your internet connection, you may have to restart the app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [usernameAlert show];
                        }
                        
                        else{
                            [standardDefaults setObject:response.owner.user.displayName  forKey:@"UserName"];
                            [standardDefaults setObject:client.accountId forKey:@"UserID"];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSegueWithIdentifier:@"fakeSegue" sender:self];
                            });
                        }
                    }];
                    
                }
                else {
                    UIAlertView *odAuthErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error signing in to OneDrive" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [odAuthErrorAlert show];
                }
            }];
        }
        
        else {
            [self performSegueWithIdentifier:@"segueToLogin" sender:self];
        }
        
    }
    
    //DELETE
    //[standardDefaults setBool:NO forKey:@"has launched"];
    
    /*
    if (![standardDefaults boolForKey:@"has launched"]) {
        [self performSegueWithIdentifier:@"segueToWalkthrough" sender:self];
        [standardDefaults  setBool:YES forKey:@"has launched"];
    }
    
    else {
        NSArray *scopeArray = [[NSArray alloc] initWithObjects:@"wl.offline_access", @"onedrive.readwrite", nil];
        
        [ODClient setMicrosoftAccountAppId:@"000000004C13496E" scopes:scopeArray];
        
        [ODClient clientWithCompletion:^(ODClient *client, NSError *error){
            if (!error){
                
                NSLog(@"Account ID: %@", client.accountId);
                
                [[[[ODClient loadCurrentClient] drive] request] getWithCompletion:^(ODDrive *response, NSError *error) {
                    if (error) {
                        UIAlertView *usernameAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Please check your internet connection, you may have to restart the app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [usernameAlert show];
                    }
                    
                    else{
                        [WelcomeViewController sharedController].userName = [response.owner.user.displayName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                        
                        [WelcomeViewController sharedController].userID = client.accountId;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"fakeSegue" sender:self];
                        });
                    }
                }];

            }
            else {
                UIAlertView *odAuthErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error signing in to OneDrive" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [odAuthErrorAlert show];
            }
        }]; //auth completion ends here
         
    } */
    
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

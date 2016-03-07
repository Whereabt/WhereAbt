//
//  AllLoginViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/15/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import "AllLoginViewController.h"
#import <InstagramSimpleOAuth/InstagramSimpleOAuth.h>
#import <OneDriveSDK/OneDriveSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <JNKeychain/JNKeychain.h>

NSString *const InstagramConstant = @"InstagramAuthentication";
NSString *const GoogleConstant = @"GoogleAuthentication";
NSString *const OneDriveConstant = @"OneDriveAuthentication";

@interface AllLoginViewController ()
{
    BOOL loginCompleted;
}
@end

@implementation AllLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   /* UIImageView *backgroundImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sesquile.JPG"]];
    backgroundImgView.frame = self.view.frame;
    [self.view addSubview:backgroundImgView];
    [self.view sendSubviewToBack:backgroundImgView]; */
    
    self.welcomeLabel.adjustsFontSizeToFitWidth = YES;
    loginCompleted = NO;
    NSUserDefaults *authInfo = [NSUserDefaults standardUserDefaults];
    BOOL silent = NO;
    [authInfo setBool:silent forKey:@"wasSilent"];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    self.activityIndicator.hidesWhenStopped = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (loginCompleted) {
        [self performSegueWithIdentifier:@"segueToInitial" sender:self];
    }
    
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
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

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[GIDSignIn sharedInstance].currentUser.userID forKey:@"UserID"];
    [defaults setObject:[GIDSignIn sharedInstance].currentUser.profile.name forKey:@"UserName"];
    NSLog(@"USERNAME:%@", [GIDSignIn sharedInstance].currentUser.profile.name);
    [JNKeychain saveValue:GoogleConstant forKey:@"AuthenticationMethod"];
    self.googleLogin.enabled = YES;
    self.igLogin.enabled = YES;
    self.odLogin.enabled = YES;
    [self performSegueWithIdentifier:@"segueToInitial" sender:self];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    [self.activityIndicator stopAnimating];
}


- (IBAction)instagramButtonPress:(id)sender {
    self.googleLogin.enabled = NO;
    self.igLogin.enabled = NO;
    self.odLogin.enabled = NO;
    [self.activityIndicator startAnimating];
    InstagramSimpleOAuthViewController
    *igVController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"a79d700aa5254341b7a1bf04de3b047b"
                                                                      clientSecret:@"331413fc7963419e8bb405854066e684"
                                                                       callbackURL:[NSURL URLWithString:@"https://n46.org/whereabt"]
                                                                        completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                            [JNKeychain saveValue:InstagramConstant forKey:@"AuthenticationMethod"];
                                                                            
                                                                            NSLog(@"My fullname is: %@", response.user.fullName);
                                                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                            [defaults setObject:response.user.userID forKey:@"UserID"];
                                                                            [defaults setObject:response.user.fullName forKey:@"UserName"];
                                                                            loginCompleted = YES;
                                                                            self.googleLogin.enabled = YES;
                                                                            self.igLogin.enabled = YES;
                                                                            self.odLogin.enabled = YES;
                                                                            NSLog(@"IG ACCESS TOKEN:%@", response.accessToken);
                                                                        }];
    igVController.shouldShowErrorAlert = YES;
    igVController.permissionScope = @[@"public_content"];
    
    [self presentViewController:igVController animated:YES completion:nil];
}

- (IBAction)microsoftButtonPress:(id)sender {
    self.googleLogin.enabled = NO;
    self.igLogin.enabled = NO;
    self.odLogin.enabled = NO;
    
    NSArray *scopeArray = [[NSArray alloc] initWithObjects:@"wl.offline_access", @"onedrive.readwrite", nil];
    [ODClient setMicrosoftAccountAppId:@"000000004C13496E" scopes:scopeArray];
    [self.activityIndicator startAnimating];
    [ODClient authenticatedClientWithCompletion:^(ODClient *client, NSError *error) {
        if (!error) {
            [[[[ODClient loadCurrentClient] drive] request] getWithCompletion:^(ODDrive *response, NSError *error) {
                self.googleLogin.enabled = YES;
                self.igLogin.enabled = YES;
                self.odLogin.enabled = YES;
                if (error) {
                    /*UIAlertView *usernameAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"A problem occurred while logging in, you may have to restart the app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [usernameAlert show];
                     */
                }
                
                else {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSLog(@"User id = %@", client.accountId);
                    [defaults setObject:client.accountId forKey:@"UserID"];
                    [defaults setObject:response.owner.user.displayName forKey:@"UserName"];
                    [JNKeychain saveValue:OneDriveConstant forKey:@"AuthenticationMethod"];
                    [self performSegueWithIdentifier:@"segueToInitial" sender:self];
                    //loginCompleted = YES;
                }
            }];
            
        }
        
        else {
            
            UIAlertView *odAuthErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error signing in to OneDrive" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [odAuthErrorAlert show];
        }
    }];

}

- (IBAction)googleButtonPress:(id)sender {
    self.googleLogin.enabled = NO;
    self.igLogin.enabled = NO;
    self.odLogin.enabled = NO;
    [self.activityIndicator startAnimating];
    [[GIDSignIn sharedInstance] signIn];
}

@end

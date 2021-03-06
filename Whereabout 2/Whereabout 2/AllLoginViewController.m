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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NSString *const GoogleConstant = @"GoogleAuthentication";
NSString *const OneDriveConstant = @"OneDriveAuthentication";

@interface AllLoginViewController ()
{
    BOOL loginCompleted;
    UIImage *sesquile;
}

@end

@implementation AllLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sesquile = [[UIImage alloc] init];
    sesquile = [UIImage imageNamed:@"sesquile.JPG"];
    self.backgroundImageView.image = sesquile;
    self.backgroundImageView.alpha = 0.4;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.welcomeLabel.adjustsFontSizeToFitWidth = YES;
    [self.welcomeLabel setText:@"Welcome to Whereabout"];
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
    
    
    /*FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.center = CGPointMake(self.odLogin.center.x, self.odLogin.center.y + 40);
    loginButton.readPermissions = @[@"public_profile", @"email"];
    [self.view addSubview:loginButton];
    
    [FBSDKSettings setAppID:@"207507326288396"];
    
    [self.fbLogin
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
     */
}

/*
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}
 */

- (void)viewDidAppear:(BOOL)animated {
    self.backgroundImageView.image = sesquile;
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

/*
-(void)loginButtonClicked
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error)
         {
             if (!error)
             {
                 //  NSDictionary *dictUser = (NSDictionary *)user;
                 // This dictionary contain user Information which is possible to get from Facebook account.
             }
         }];
    }

    else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error)
              {
                  if (!error)
                  {
                      //  NSDictionary *dictUser = (NSDictionary *)user;
                      // This dictionary contain user Information which is possible to get from Facebook account.
                  }
              }];
             
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
             }
         }];
    }
} */


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (!error) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[GIDSignIn sharedInstance].currentUser.userID forKey:@"UserID"];
        [defaults setObject:[GIDSignIn sharedInstance].currentUser.profile.name forKey:@"UserName"];
        NSLog(@"USERNAME:%@", [GIDSignIn sharedInstance].currentUser.profile.name);
        [JNKeychain saveValue:GoogleConstant forKey:@"AuthenticationMethod"];
        self.googleLogin.enabled = YES;
        self.odLogin.enabled = YES;
        [self performSegueWithIdentifier:@"segueToInitial" sender:self];
    }
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[GIDSignIn sharedInstance].currentUser.userID forKey:@"UserID"];
    [defaults setObject:[GIDSignIn sharedInstance].currentUser.profile.name forKey:@"UserName"];
    NSLog(@"USERNAME:%@", [GIDSignIn sharedInstance].currentUser.profile.name);
    [JNKeychain saveValue:GoogleConstant forKey:@"AuthenticationMethod"];
    self.googleLogin.enabled = YES;
    self.odLogin.enabled = YES;
    [self performSegueWithIdentifier:@"segueToInitial" sender:self];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    [self.activityIndicator stopAnimating];
}


- (IBAction)microsoftButtonPress:(id)sender {
    //self.googleLogin.enabled = NO;
   // self.odLogin.enabled = NO;
    
    NSArray *scopeArray = [[NSArray alloc] initWithObjects:@"wl.offline_access", @"onedrive.readwrite", nil];
    [ODClient setMicrosoftAccountAppId:@"000000004C13496E" scopes:scopeArray];
    [self.activityIndicator startAnimating];
    [ODClient authenticatedClientWithCompletion:^(ODClient *client, NSError *error) {
        if (!error) {
            [[[[ODClient loadCurrentClient] drive] request] getWithCompletion:^(ODDrive *response, NSError *error) {
                self.googleLogin.enabled = YES;
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
    self.odLogin.enabled = NO;
    [self.activityIndicator startAnimating];
    [[GIDSignIn sharedInstance] signIn];
}

@end

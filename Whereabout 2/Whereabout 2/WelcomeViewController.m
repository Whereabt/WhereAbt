//
//  WelcomeViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 12/10/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PhotosAccessViewController.h"
#import "LocationController.h"
#import "ProfileController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>


@interface WelcomeViewController ()

@end

@implementation WelcomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
    //[keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
    NSLog(@"KEYCHAIN value data key at app launch: %@", [keychain objectForKey:(__bridge id)(kSecValueData)]);
    
    /*
    if ([[keychain objectForKey:(__bridge id)(kSecValueData)] length] > 1) {
        
        //refresh the access token
        [WelcomeViewController sharedController].refreshToken = [keychain objectForKey:(__bridge id)(kSecValueData)];
        
        NSLog(@"Refresh token property value before refresh called: %@", [WelcomeViewController sharedController].refreshToken);
        
        [self refreshAuthToken];
        //[self setAuthTokenRefreshTokenAndProfileNamesFromCode:[keychain objectForKey:(__bridge id)(kSecValueData)]];
        [self performSegueWithIdentifier:@"segueToTab" sender:self];
    }
    
    
    else {
        NSLog(@"User did not have a stored refresh token in his keychain.");
    }
    */
    
    if ([WelcomeViewController sharedController].refreshToken != nil) {
        [self performSegueWithIdentifier:@"segueToTab" sender:self];
        NSLog(@"User had a stored refresh token");
    }
    else {
        NSLog(@"User did not have a stored refresh token; continuing on with 'welcome view' ");
    }
}

- (void)refreshAuthTokenWithCompletion:(void (^)(void)) callback {
    NSString *urlAsString = [NSString stringWithFormat:@"https://login.live.com/oauth20_token.srf?client_id=000000004C13496E&client_secret=tBdSMDxUm5h0HWSdtCtsU1ImTAfrqYxt&redirect_uri=https://n46.org/whereabt/redirect.html&grant_type=refresh_token&refresh_token=%@", [WelcomeViewController sharedController].refreshToken];
    
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response, NSError *error){
                                                       NSError *jsonError = nil;
                                                       NSDictionary *immutable =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                                       
                                                       [WelcomeViewController sharedController].authToken = immutable[@"access_token"];
                                                       [WelcomeViewController sharedController].refreshToken = immutable[@"refresh_token"];
                                                      
                                                       //store refresh token
                                                       KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
                                                       if (![[WelcomeViewController sharedController].refreshToken  isEqual: @""]) {
                                                           
                                                           [keychain setObject: [WelcomeViewController sharedController].refreshToken forKey:(__bridge id)kSecValueData];
                                                       }
                                                       
                                                       else {
                                                           NSLog(@"Cannot store the refresh token in keychain if it has not yet been found");
                                                       }

                                                       ProfileController *profileManager = [[ProfileController alloc]init];
                                                       
                                                       [profileManager getProfilePropertiesWithCompletion:^(NSDictionary *profileItems, NSError *error) {
                                                           
                                                           [WelcomeViewController sharedController].userName = [profileItems[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                                                           [WelcomeViewController sharedController].userID = profileItems[@"id"];
                                                           callback();
                                                       }];
                                                    
                                                   }];
    [dataRequestTask resume];
}

- (void)setAuthTokenRefreshTokenAndProfileNamesFromCode:(NSString *)authCode{
    NSString *urlAsString = [NSString stringWithFormat:@"https://login.live.com/oauth20_token.srf?client_id=000000004C13496E&client_secret=tBdSMDxUm5h0HWSdtCtsU1ImTAfrqYxt&redirect_uri=https://n46.org/whereabt/redirect.html&code=%@&grant_type=authorization_code", authCode];
    
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response, NSError *error){
                                                       NSError *jsonError = nil;
                                                       NSDictionary *immutable =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                                       
                                                 if (jsonError == nil) {
                                                       [WelcomeViewController sharedController].authToken = immutable[@"access_token"];
                                                       [WelcomeViewController sharedController].refreshToken = immutable[@"refresh_token"];
                                                       NSLog(@"RefreshTOKEN: %@", [WelcomeViewController sharedController].refreshToken);
                                                      
                                                       KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
                                                       
                                                       [keychain setObject: [WelcomeViewController sharedController].refreshToken forKey:(__bridge id)(kSecValueData)];
                                                       
                                                       //get other properties from user
                                                       ProfileController *profileManager = [[ProfileController alloc]init];
                                                       
                                                       [profileManager getProfilePropertiesWithCompletion:^(NSDictionary *profileProperties, NSError *error) {
                                                           
                                                           [WelcomeViewController sharedController].userName = [profileProperties[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                                                           [WelcomeViewController sharedController].userID = profileProperties[@"id"];
                                                        }];
                                                    }
                                                    
                                                    else {
                                                           NSLog(@"Error getting tokens from the auth code, the error code: %@", jsonError);
                                                        UIAlertView *authAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered an error while trying to log you in. This could be due to your network connection; please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                        
                                                        [authAlert show];
                                                    }
                                           }];
    [dataRequestTask resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)sharedController {
    static WelcomeViewController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue destinationViewController];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)LoginSignUp:(id)sender {
    //make user log in to get him an auth code
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    webView.delegate = self;
    
    //wl.skydrive_update <--a scope
    //wl.offline_access  <--- another scope, used to
    NSString *urlAsString = @"https://login.live.com/oauth20_authorize.srf?client_id=000000004C13496E&scope=wl.offline_access,onedrive.readwrite&response_type=code&redirect_uri=https://n46.org/whereabt/redirect.html";
    //https://n46.org/whereabt/redirect.html
    NSURL *authURL = [[NSURL alloc]initWithString:urlAsString];
    NSURLRequest *loginRequest = [NSURLRequest requestWithURL:authURL];
    [webView loadRequest:loginRequest];
    [self.view addSubview:webView];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Url: %@", request.URL.absoluteString);
    
    if ([request.URL.absoluteString containsString:@"?code="]) {
        NSArray *urlParts = [request.URL.absoluteString componentsSeparatedByString:@"?code="];
        
        if ([urlParts[0] isEqual: @"https://n46.org/whereabt/redirect.html"] == YES)
        {
            //NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
            [WelcomeViewController sharedController].authCode = urlParts[1];
            
            
            [self setAuthTokenRefreshTokenAndProfileNamesFromCode:[WelcomeViewController sharedController].authCode];
            
            KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
            
            [keychain setObject:[WelcomeViewController sharedController].userName forKey:(__bridge id)kSecAttrAccount];
            
            [keychain setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
            
            
            //store refresh token
            if (![[WelcomeViewController sharedController].refreshToken  isEqual: @""]) {
                
                [keychain setObject: [WelcomeViewController sharedController].refreshToken forKey:(__bridge id)kSecValueData];
                
                //OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
                //NSLog(@"Error code: %d", (int)sts);
            }
            
            else {
                NSLog(@"Cannot store the refresh token in keychain if it has not yet been found");
            }
            
            NSLog(@"The 'Value Data' code of the user: %@", [keychain objectForKey:(__bridge id)(kSecValueData)]);
            [webView removeFromSuperview];
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            
            
            if ([preferences boolForKey:@"Done Walkthrough"] == NO) {
                [self performSegueWithIdentifier:@"segueToIntro" sender:self];
                [preferences setBool:YES forKey:@"Done Walkthrough"];
            }
            
            else {
                //already done walkthrough
                [self performSegueWithIdentifier:@"segueToTab" sender:self];
                
            }
          
        }
        
        else{
            //do something when OD API returns invalid url
            NSLog(@"Redirect url invalid");
        }

    }
    
    else {
        NSLog(@"Redirect URL does not include code");
    }

   
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

@end

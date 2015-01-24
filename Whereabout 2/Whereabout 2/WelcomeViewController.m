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


@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
{
    KeychainItemWrapper *keychain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   /* keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Login" accessGroup:nil];
    if (![[keychain objectForKey:(__bridge id)(kSecValueData)]  isEqual: @""]) {
        //get a fresh token from the auth code
        [self setAuthTokenRefreshTokenAndProfileNamesFromCode:[keychain objectForKey:(__bridge id)(kSecValueData)]];
        [self performSegueWithIdentifier:@"segueToTab" sender:self];
    }
    
    else{
        NSLog(@"User did not have a stored code in his keychain.");
    }
    // Do any additional setup after loading the view.
    */
}

- (void)refreshAuthToken{
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
                                                       
                                                       [WelcomeViewController sharedController].authToken = immutable[@"access_token"];
                                                       [WelcomeViewController sharedController].refreshToken = immutable[@"refresh_token"];
                                                       NSLog(@"RefreshTOKEN: %@", [WelcomeViewController sharedController].refreshToken);
                                                       //get other properties from user
                                                       ProfileController *profileManager = [[ProfileController alloc]init];
                                                       [profileManager requestProfileItemsWithCompletion:^(NSDictionary *profileItems, NSError *error) {
                                                           [WelcomeViewController sharedController].userName = [profileItems[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                                                           [WelcomeViewController sharedController].userID = profileItems[@"id"];
                                                            }];
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
    NSString *urlAsString = @"https://login.live.com/oauth20_authorize.srf?client_id=000000004C13496E&scope=wl.skydrive_update&response_type=code&redirect_uri=https://n46.org/whereabt/redirect.html";
    NSURL *authURL = [[NSURL alloc]initWithString:urlAsString];
    NSURLRequest *loginRequest = [NSURLRequest requestWithURL:authURL];
    [webView loadRequest:loginRequest];
    [self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Url: %@", request.URL.absoluteString);
    NSArray *urlParts = [request.URL.absoluteString componentsSeparatedByString:@"?code="];
    
    if ([urlParts[0] isEqual: @"https://n46.org/whereabt/redirect.html"] == YES)
    {
        
        [WelcomeViewController sharedController].authCode = urlParts[1];
        /*
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"Login" accessGroup:nil];
         */
        
        [keychain setObject:[WelcomeViewController sharedController].authCode forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];

        NSLog(@"The 'Value Data' code of the user: %@", [keychain objectForKey:(__bridge id)(kSecValueData)]);
        [self setAuthTokenRefreshTokenAndProfileNamesFromCode:[WelcomeViewController sharedController].authCode];
        [webView removeFromSuperview];
        [self performSegueWithIdentifier:@"segueToTab" sender:self];
    }
    
    else{
        //do something when OD API returns invalid url
        NSLog(@"Redirect url invalid");
    }
 
   
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

@end

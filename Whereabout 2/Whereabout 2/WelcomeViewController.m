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

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
- (instancetype)init{
    if (self = [super init]) {
        _authToken = [[NSString alloc]init];
        
    }
    return self;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue destinationViewController];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)LoadPhotoView:(id)sender {
}

- (IBAction)LoginSignUp:(id)sender {
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
        NSString *code = urlParts[1];
        NSLog(@"%@", code);
        
        NSArray *tokenAndMore = [urlParts[1] componentsSeparatedByString:@"&authentication_token="];
      [WelcomeViewController sharedController].authToken = tokenAndMore[0];
        
        NSLog(@"TOKEN:%@", tokenAndMore[0]);
        ProfileController *profileManager = [[ProfileController alloc]init];
        [profileManager requestProfileItemsWithCompletion:^(NSDictionary *profileItems, NSError *error) {
            [WelcomeViewController sharedController].userName = profileItems[@"name"];
            [WelcomeViewController sharedController].userID = profileItems[@"id"];
        }];

        [webView removeFromSuperview];
    }
    
    else{
        //do something when OD API returns invalid url
        NSLog(@"Token was not inside of this query string");
    }
 
   
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

@end

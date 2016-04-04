//
//  AppDelegate.m
//  Whereabout 2
//
//  Created by Nicolas on 12/7/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationController.h"
#import "WelcomeViewController.h"
#import "KeychainItemWrapper.h"
#import "InitialViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <Google/Analytics.h>
#import "TabBarAppViewController.h"
#import "AllLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"Initial VC"]];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255.0f/255.0f green:174.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
   
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
    pageControl.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                                  green:33.0f/255.0f
                                                   blue:36.0f/255.0f
                                                  alpha:1.0f];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
   // gai.logger.logLevel = kGAILogLevelVerbose; //REMOVE BEFORE APP RELEASE
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
                              UIApplicationOpenURLOptionsAnnotationKey: annotation};
    /*
    if ([url.scheme  isEqual: @"fb207507326288396"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    
    else {
        return [self application:application
                     openURL:url
                     options:options];
    }
    */
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation] || [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation ];

}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"google" forKey:@"AuthType"];
    [defaults setObject:[GIDSignIn sharedInstance].currentUser.userID forKey:@"UserID"];
    [defaults setObject:[GIDSignIn sharedInstance].currentUser.profile.name forKey:@"UserName"];
    
    //TabBarAppViewController *tabBarVC = [[TabBarAppViewController alloc] init];
    [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabBarVC"]];

    // Perform any operations on signed in user here.

    // ...
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

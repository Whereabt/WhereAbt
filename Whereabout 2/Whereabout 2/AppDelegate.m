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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    //WelcomeViewController *welcomeController = [[WelcomeViewController alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"Initial VC"]];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255.0f/255.0f green:174.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
   
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
    pageControl.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                                  green:33.0f/255.0f
                                                   blue:36.0f/255.0f
                                                  alpha:1.0f];
    
    //timer fires every 55 minutes
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:3300];
    NSLog(@"%@", fireDate);
    
    NSTimer *authTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:3300 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    [authTimer fire];
    
    return YES;
}

- (void)timerFireMethod: (NSTimer *)theTimer {
    WelcomeViewController *welcomeCont = [[WelcomeViewController alloc] init];
    [welcomeCont refreshAuthTokenWithCompletion:^{
        //no completion needed
    }];
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

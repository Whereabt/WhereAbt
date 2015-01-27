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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    /*
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    
    tabBarItem1.title = @"Upload";
    tabBarItem2.title = @"Stream";
    tabBarItem3.title = @"Stream 2";
    tabBarItem4.title = @"Profile";
    tabBarItem5.title = @"Settings";
    
    //images
    tabBarItem1.image = [UIImage imageNamed:@"icon-Upload GRAY 50x50.png"];
    tabBarItem1.selectedImage = [UIImage imageNamed:@"icon-Upload 50x50.png"];
    tabBarItem2.image = [UIImage imageNamed:@"icon-Feed GRAY 50x50.png"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"icon-Feed 50x50.png"];
    tabBarItem4.image = [UIImage imageNamed:@"icon-Profile GRAY 50x50.png"];
    tabBarItem4.selectedImage = [UIImage imageNamed:@"icon-Profile 50x50.png"];
    tabBarItem5.image = [UIImage imageNamed:@"icon-Settings GRAY 50x50.png"];
    tabBarItem5.selectedImage = [UIImage imageNamed:@"icon-Settings 50x50.png"];
                            
     */
    
    WelcomeViewController *welcomeController = [[WelcomeViewController alloc] init];
    
    //timer fires every 55 minutes
    NSTimer *authTokenRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:3300 target:welcomeController selector:@selector(refreshAuthToken) userInfo:nil repeats:YES];
   [authTokenRefreshTimer fire];
    
    return YES;
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

//
//  TabBarAppViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 2/14/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "TabBarAppViewController.h"
#import "ProfileViewController.h"
#import "PhotosAccessViewController.h"
#import "StreamCollectionViewController.h"

@interface TabBarAppViewController ()

@end

@implementation TabBarAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSArray *viewControllersArray = [NSArray alloc] initWithObjects: , nil
    NSLog(@"View controllers of tab bar controller: %@", self.viewControllers);
    
    //customizing tab bar items for the three views
    UIImage *streamNormalImage = [UIImage imageNamed:@"Near Me.png"];
    //UIImage *streamSelectedImage = [UIImage imageNamed:@"Whereabout-feed-tab-BLUE-10-06-2015.png"];
    UITabBarItem *streamTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:streamNormalImage selectedImage:[UIImage imageNamed:@"Near Me Filled.png"]];
    [self.viewControllers[0] setTabBarItem:streamTabBarItem];
    
    UIImage *profileNormalImage = [UIImage imageNamed:@"Gender Neutral User.png"];
    //UIImage *profileSelectedImage = [UIImage imageNamed:@"Whereabout-profile-tab-BLUE-10-06-2015.png"];
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:profileNormalImage selectedImage:[UIImage imageNamed:@"Gender Neutral User Filled.png"]];
    [self.viewControllers[1] setTabBarItem:profileTabBarItem];
    
    UIImage *settingsNormalImage = [UIImage imageNamed:@"Maintenance.png"];
    //UIImage *settingsSelectedImage = [UIImage imageNamed:@"Whereabout-settings-tab-BLUE-10-06-2015.png"];
    UITabBarItem *settingsTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:settingsNormalImage selectedImage:[UIImage imageNamed:@"Maintenance Filled.png"]];
    [self.viewControllers[2] setTabBarItem:settingsTabItem];
    /*
    UIImage *streamNormalImage = [UIImage imageNamed:@"rsz_45whereabout-feed-gray-05-11-2015.png"];
    //UIImage *streamSelectedImage = [UIImage imageNamed:@"Whereabout-feed-tab-BLUE-10-06-2015.png"];
    UITabBarItem *streamTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:streamNormalImage selectedImage:nil];
    [self.viewControllers[0] setTabBarItem:streamTabBarItem];
    
    UIImage *profileNormalImage = [UIImage imageNamed:@"rsz_1whereabout_profile_tab-09-20-2015_gray.png"];
    //UIImage *profileSelectedImage = [UIImage imageNamed:@"Whereabout-profile-tab-BLUE-10-06-2015.png"];
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:profileNormalImage selectedImage:nil];
    [self.viewControllers[1] setTabBarItem:profileTabBarItem];
    
    UIImage *settingsNormalImage = [UIImage imageNamed:@"rsz45_whereabout-settings-gray-05-11-2015.png"];
    //UIImage *settingsSelectedImage = [UIImage imageNamed:@"Whereabout-settings-tab-BLUE-10-06-2015.png"];
    UITabBarItem *settingsTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:settingsNormalImage selectedImage:nil];
    [self.viewControllers[2] setTabBarItem:settingsTabItem]; */
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

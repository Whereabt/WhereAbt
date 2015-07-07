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
    /*
    UIImage *uploadNormalImage = [UIImage imageNamed:@"Whereabout-upload-gray-05-11-2015.png"];
    UIImage *uploadSelectedImage = [UIImage imageNamed:@"Whereabout-upload-orange-05-11-2015.png"];
    UITabBarItem *uploadTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:uploadNormalImage selectedImage:uploadSelectedImage];
    [self.viewControllers[0] setTabBarItem:uploadTabBarItem];
    */
    
    UIImage *streamNormalImage = [UIImage imageNamed:@"Whereabout-feed-gray-05-11-2015.png"];
    UIImage *streamSelectedImage = [UIImage imageNamed:@"Whereabout-feed-orange-05-11-2015.png"];
    UITabBarItem *streamTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:streamNormalImage selectedImage:streamSelectedImage];
    [self.viewControllers[0] setTabBarItem:streamTabBarItem];
    
    UIImage *profileNormalImage = [UIImage imageNamed:@"Whereabout-profile-gray-05-11-2015.png"];
    UIImage *profileSelectedImage = [UIImage imageNamed:@"Whereabout-profile-orange-05-11-2015.png"];
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:profileNormalImage selectedImage:profileSelectedImage];
    [self.viewControllers[1] setTabBarItem:profileTabBarItem];
    
    UIImage *settingsNormalImage = [UIImage imageNamed:@"Whereabout-settings-gray-05-11-2015.png"];
    UIImage *settingsSelectedImage = [UIImage imageNamed:@"Whereabout-settings-orange-05-11-2015.png"];
    UITabBarItem *settingsTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:settingsNormalImage selectedImage:settingsSelectedImage];
    [self.viewControllers[2] setTabBarItem:settingsTabItem];
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

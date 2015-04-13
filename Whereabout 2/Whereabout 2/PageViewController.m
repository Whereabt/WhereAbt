//
//  PageViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/4/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSMutableArray *viewcontrollers = [[NSMutableArray alloc] init];
    
    UIViewController *uploadVC = [storyboard instantiateViewControllerWithIdentifier:@"Upload VC"];
    [viewcontrollers addObject:uploadVC];
    
    UIViewController *streamVC = [storyboard instantiateViewControllerWithIdentifier:@"StreamNavVC"];
    [viewcontrollers addObject:streamVC];
    
    UIViewController *profileVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileNavVC"];
    [viewcontrollers addObject:profileVC];
    
    
    [pageVC setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

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

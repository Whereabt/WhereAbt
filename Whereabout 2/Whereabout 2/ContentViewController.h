//
//  ContentViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/4/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic)UIPageViewController *pageViewController;

@end
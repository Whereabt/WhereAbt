//
//  DefaultViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface DefaultViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)beginWalkthrough:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end

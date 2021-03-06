//
//  ContentViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/4/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property (strong, nonatomic) IBOutlet UIImageView *pageImage;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;

- (void)setUpPageFromName:(NSString *)imageName andTitle:(NSString *)titleText;

@end

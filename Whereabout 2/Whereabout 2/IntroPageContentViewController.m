//
//  ContentViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/4/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "IntroPageContentViewController.h"

@interface IntroPageContentViewController ()

//@property NSUInteger pageIndex;

@end

@implementation IntroPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpPageFromName:(NSString *)imageName andTitle:(NSString *)titleText {
    
    self.pageImage.image = [UIImage imageNamed:imageName];
    
    NSLog(@"Title text: %@",[NSString stringWithFormat:@"%@", titleText]);
    
    [self.pageTitle setText: titleText];
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

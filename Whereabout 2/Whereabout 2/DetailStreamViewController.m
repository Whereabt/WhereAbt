//
//  DetailStreamViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 2/8/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "DetailStreamViewController.h"

@interface DetailStreamViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation DetailStreamViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = self.image;
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

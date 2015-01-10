//
//  WelcomeViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 12/10/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PhotosAccessViewController.h"
#import "LocationController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [segue destinationViewController];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)LoadPhotoView:(id)sender {
}
@end

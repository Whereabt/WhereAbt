//
//  InitialSegueViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 5/5/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "InitialSegueViewController.h"

@interface InitialSegueViewController ()

@end

@implementation InitialSegueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self performSegueWithIdentifier:@"fakeSecondSegue" sender:self];
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

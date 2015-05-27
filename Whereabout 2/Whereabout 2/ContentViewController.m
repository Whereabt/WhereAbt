//
//  ContentViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/4/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

//@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageImage.image = [UIImage imageNamed:self.imageFile];
    self.pageTitle.text = self.titleText;
    // Do any additional setup after loading the view.
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

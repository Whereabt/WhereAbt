//
//  EnlargedCellViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "EnlargedCellViewController.h"

@interface EnlargedCellViewController ()

@end

@implementation EnlargedCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageForEnlargedImageUsingImage:(UIImage*) photo{
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
    
    self.enlargedImage.image = [UIImage imageWithData: imageData];
    self.enlargedImage.frame = CGRectMake(0, 0, photo.size.width, photo.size.height);
}

- (void)setTextForUsernameLabel:(NSString *) text{
    self.enlargedName.text = text;
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

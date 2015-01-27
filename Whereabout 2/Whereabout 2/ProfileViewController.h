//
//  ProfileViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/20/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController //<UICollectionViewDataSource, UICollectionViewDelegate>;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *LastNameLabel;

@end

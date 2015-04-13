//
//  StreamPROCollectionHeaderView.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamPROCollectionHeaderView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postsLabel;

@end

//
//  CellViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/17/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageOfCell;
@property (strong, nonatomic) IBOutlet UILabel *labelOfCell;

@end
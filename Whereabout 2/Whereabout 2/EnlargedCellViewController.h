//
//  EnlargedCellViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlargedCellViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *enlargedImage;
@property (weak, nonatomic) IBOutlet UILabel *enlargedName;

- (void)setImageForEnlargedImageUsingImage:(UIImage*) photo;
- (void)setTextForUsernameLabel:(NSString *) text;

@end

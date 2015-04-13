//
//  ProfileEnlargedViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileEnlargedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *largeImageView;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;

- (IBAction)longPressGesture:(id)sender;
- (void)setUpEnlargedViewWithDistance: (NSString *)distanceString andPhoto:(UIImage *)photo;

@end

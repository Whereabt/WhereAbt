//
//  StreamPROEnlargedViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamPROEnlargedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressButton;

- (IBAction)longPressButtonPressed:(id)sender;
- (void)setUpEnlargedViewWithDistanceString:(NSString *) distanceString andPhoto:(UIImage *)photo;

@end

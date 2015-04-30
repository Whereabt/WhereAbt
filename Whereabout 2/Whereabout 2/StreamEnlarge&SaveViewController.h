//
//  StreamEnlarge&SaveViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/29/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamEnlarge_SaveViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *theImageView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *nameButton;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setUpTheEnlargedViewWithItemDictionary:(NSMutableDictionary *)imageItem;
- (IBAction)nameButtonPressed:(id)sender;
- (IBAction)longButtonPress:(id)sender;

- (UIColor *)getBackgroundColor;

@end

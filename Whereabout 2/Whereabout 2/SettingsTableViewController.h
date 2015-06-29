//
//  SettingsTableViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/2/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
@property (strong, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) IBOutlet UISwitch *saveSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *logoutActivityIndicator;
- (IBAction)logoutPressed:(id)sender;
- (IBAction)switchChange:(id)sender;
- (IBAction)sliderChange:(id)sender;

@end

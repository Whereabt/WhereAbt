//
//  SettingsTableViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/2/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISwitch *mappingSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *logoutActInd;
@property (weak, nonatomic) IBOutlet UISwitch *saveSwitch;
- (IBAction)saveSwitchChange:(id)sender;
- (IBAction)mappSwitchChange:(id)sender;
- (IBAction)logoutPress:(id)sender;

@end

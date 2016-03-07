//
//  SideMenuTableViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 2/28/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *autoSaveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mappingSwitch;
- (IBAction)mapChange:(id)sender;
- (IBAction)saveChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@end

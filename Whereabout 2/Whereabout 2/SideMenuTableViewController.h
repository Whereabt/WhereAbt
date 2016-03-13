//
//  SideMenuTableViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 2/28/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;

- (IBAction)timeSlideChange:(id)sender;
- (IBAction)distanceSlideChange:(id)sender;

@end

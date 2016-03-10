//
//  SideMenuTableViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 2/28/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "SWRevealViewController.h"
#import "SettingsTableViewController.h"
#import "StreamViewController.h"

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = @[@"stream", @"camera", @"camera roll", @"profile", @"settings"];
    self.revealViewController.rearViewRevealWidth = 200;
    //[self.tableView reloadData];
    self.tableView.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                                     green:33.0f/255.0f
                                                      blue:36.0f/255.0f
                                                     alpha:1.0f];
    NSUserDefaults *standards = [NSUserDefaults standardUserDefaults];
    
    NSArray *namesArray = [[standards objectForKey:@"UserName"] componentsSeparatedByString:@" "];
    [self.usernameLabel setText:namesArray[0]];
    [self.lastNameLabel setText:namesArray[1]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
 /*   // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showSettings"]) {
        UINavigationController *navController = segue.destinationViewController;
    }
  */
    StreamViewController *streamVC = [[StreamViewController alloc] init];
    if ([segue.identifier  isEqual: @"showRecent"]) {
        [streamVC setSortTypeTo:@"time"];
    }
    else if ([segue.identifier  isEqual: @"showStream"]) {
        [streamVC setSortTypeTo:@"distance"];
    }
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    if (indexPath.row == 0) {
        [textLabel setText:@"Stream"];
    }
    else if (indexPath.row == 1) {
        [textLabel setText:@"Camera"];
    }
    else if (indexPath.row == 2) {
        [textLabel setText:@"Camera Roll"];
    }
    else if (indexPath.row == 3) {
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        [textLabel setText:[standardDefaults objectForKey:@"UserName"]];
    }
    else if (indexPath.row == 4) {
        [textLabel setText:@"Settings"];
    }
    
    [textLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];

    [textLabel setFrame:CGRectMake(5, 0, self.revealViewController.rearViewRevealWidth - 5, 50)];
    [textLabel setBackgroundColor:[UIColor colorWithRed:31.0f/255.0f
                                                  green:33.0f/255.0f
                                                   blue:36.0f/255.0f
                                                  alpha:1.0f]];
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundView = textLabel; 
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

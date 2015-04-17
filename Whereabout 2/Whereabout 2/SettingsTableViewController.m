//
//  SettingsTableViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/2/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:@"autoSave"] isEqualToString:@"YES"]) {
        [self.saveSwitch setOn:YES];
    }
    
    NSLog(@"Default radius: %f", [preferences floatForKey:@"Radius Slider"]);
    
    if ([preferences floatForKey:@"Radius Slider"] == 0) {
        [preferences setFloat:self.radiusSlider.value forKey:@"Radius Slider"];
        
        //set label
        float foo = self.radiusSlider.value * 3;
        [self.radiusLabel setText:[NSString stringWithFormat:@"%f Miles", foo]];
    }
    
    else {
        [self.radiusSlider setValue:[preferences floatForKey:@"Radius Slider"]];
        
        //set label
        float x = self.radiusSlider.value * 3;
        [self.radiusLabel setText:[NSString stringWithFormat:@"Stream Radius: %f Miles", x]];

    }
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutPressed:(id)sender {
    
}

- (IBAction)switchChange:(id)sender {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *autoSave;
    
    if (![self.saveSwitch isOn]) {
         autoSave = @"NO";
    }
    else {
        autoSave = @"YES";
    }
    
    [preferences setObject:autoSave forKey:@"autoSave"];
}

- (IBAction)sliderChange:(id)sender {
    //change default
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setFloat:self.radiusSlider.value forKey:@"Radius Slider"];
    
    //change label text
    
    float y = self.radiusSlider.value * 3;
    [self.radiusLabel setText:[NSString stringWithFormat:@"Stream Radius: %f Miles", y]];
    
}


#pragma mark - Table view data source

/* STATIC CELLS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
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

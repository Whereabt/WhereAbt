//
//  SettingsTableViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 4/2/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "WelcomeViewController.h"
#import <OneDriveSDK/OneDriveSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <JNKeychain/JNKeychain.h>

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.allowsSelection = NO;
    self.logoutActivityIndicator.hidesWhenStopped = YES;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([[preferences objectForKey:@"autoSave"] isEqualToString:@"YES"]) {
        [self.saveSwitch setOn:YES];
    }
    
    if ([[preferences objectForKey:@"mapping"] isEqualToString:@"TRUE"]) {
        [self.mappingSwitch setOn:YES];
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
    [self.logoutActivityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"AuthType"]  isEqual: @"instagram"]) {
        [JNKeychain deleteValueForKey:@"igAuthCode"];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *each in [cookieStorage cookiesForURL:[NSURL URLWithString:@"https://api.instagram.com"]]) {
            [cookieStorage deleteCookie:each];
        }
        [self.logoutActivityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"segueToLogout" sender:self];
    }
    
    else if ([[defaults objectForKey:@"AuthType"]  isEqual: @"onedrive"]) {
        [[ODClient loadCurrentClient] signOutWithCompletion:^(NSError *erro) {
            if (erro) {
                UIAlertView *logoutFailAlert = [[UIAlertView alloc] initWithTitle:@"Logout Failed" message:@"An error occurred" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [logoutFailAlert show];
            }
            else {
                [self.logoutActivityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"segueToLogout" sender:self];
            }
        }];
    }
    
    else if ([[defaults objectForKey:@"AuthType"]  isEqual: @"google"]) {
        [[GIDSignIn sharedInstance] signOut];
        [self.logoutActivityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"segueToLogout" sender:self];
    }
    
    /* ---> OLD WAY
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
    
    //set nil for the refresh token, user will have to log back in
    [WelcomeViewController sharedController].refreshToken = @"";
    
    [keychain setObject:[WelcomeViewController sharedController].refreshToken forKey:(__bridge id)kSecValueData];
    NSURL *url = [NSURL URLWithString:@"https://login.live.com/oauth20_logout.srf?client_id=000000004C13496E&redirect_uri=https://n46.org/whereabt/redirect.html"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //completion
        NSLog(@"Response from logout: %@", response);
        [self.logoutActivityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"segueToLogout" sender:self];
    }];
    
    [dataRequestTask resume];
    */
    
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

- (IBAction)mappingSwitchChange:(id)sender {
    
    NSString *mappingPreference;
    if ([self.mappingSwitch isOn]) {
        mappingPreference = @"TRUE";
    }
    else {
        mappingPreference = @"FALSE";
    }
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:mappingPreference forKey:@"mapping"];
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

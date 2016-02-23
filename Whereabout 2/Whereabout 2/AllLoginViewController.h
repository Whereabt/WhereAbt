//
//  AllLoginViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/15/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>


@interface AllLoginViewController : UIViewController <GIDSignInUIDelegate, GIDSignInDelegate>
- (IBAction)instagramButtonPress:(id)sender;
- (IBAction)microsoftButtonPress:(id)sender;
- (IBAction)googleButtonPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *igLogin;
@property (weak, nonatomic) IBOutlet UIButton *googleLogin;
@property (weak, nonatomic) IBOutlet UIButton *odLogin;

@end

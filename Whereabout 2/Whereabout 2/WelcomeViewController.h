//
//  WelcomeViewController.h
//  Whereabout 2
//
//  Created by Nicolas on 12/10/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController


//create outlet property for "Get Started" button
@property (weak, nonatomic) IBOutlet UIButton *GetStarted;
- (IBAction)LoadPhotoView:(id)sender; //action method for "Get Started" button

@end

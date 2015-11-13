//
//  ReportViewController.h
//  Whereabout 2
//
//  Created by Casa on 11/7/15.
//  Copyright © 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
- (IBAction)dontLikePress:(id)sender;
- (IBAction)scamSpamPress:(id)sender;
- (IBAction)riskPress:(id)sender;
- (IBAction)doesntBelongPress:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dontLikeButton;
@property (weak, nonatomic) IBOutlet UIButton *scameSpamButton;
@property (weak, nonatomic) IBOutlet UIButton *riskButton;
@property (weak, nonatomic) IBOutlet UIButton *doesntBelongButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)getPhotoIdToReportVC: (NSString *)photoId;

@end

//
//  StreamViewController.h
//  Whereabout 2
//
//  Created by Nicolas on 1/1/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StreamViewController : UITableViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *tableActivityIndicator;

- (IBAction)savedPhotoAlbumButtonCalled:(id)sender;
- (IBAction)cameraButtonCalled:(id)sender;
- (void)closePhotoVCWithCompletion:(void (^)(void))completionBlock;
- (void)setSortTypeTo:(NSString *)sortIdentifier;
- (void)stopRefreshControlOnPhotoUpload;
- (void)startRefreshControlOnPhotoUpload;
- (void)setUploadingPhotoVarTo:(BOOL) boolean;
- (BOOL)uploadingPhoto;

@end

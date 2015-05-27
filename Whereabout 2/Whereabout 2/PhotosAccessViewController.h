//
//  PhotosAccessViewController.h
//  Whereabout 2
//
//  Created by Nicolas on 12/20/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosAccessViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//create property to indicate whether or not the image selected by the user, regardless of its source, is new or old.
@property BOOL newMedia;

//outlet created for UIImageView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//establishing action methods for the two bar button items

- (IBAction)fromCamera:(id)sender;
- (IBAction)fromCameraRoll:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *uploadActivityIndicator;

@end

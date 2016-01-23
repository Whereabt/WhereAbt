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
@property (strong, nonatomic) id delegate;
//establishing action methods for the two bar button items

- (void)takePhotoFromCamera;
- (void)cancelTakePhotoEvent;
- (void)switchCamera;
- (void)selectFromCameraRoll;
- (void)setSourceTypeToWantsCamera:(BOOL) wantsCameraBool;


@end

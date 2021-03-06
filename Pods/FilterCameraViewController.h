//
//  FilterCameraViewController.h
//  Pods
//
//  Created by Nicolas Isaza on 1/5/16.
//
//

#import <UIKit/UIKit.h>

@interface FilterCameraViewController : UIViewController <UIActionSheetDelegate>
- (IBAction)takePhotoPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

//- (void)takePhotoButtonPressed;

- (IBAction)filterItemPressed:(id)sender;
- (IBAction)switchItemPressed:(id)sender;

@end

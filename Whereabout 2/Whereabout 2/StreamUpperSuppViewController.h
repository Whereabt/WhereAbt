//
//  StreamUpperSuppViewControllerCollectionReusableView.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 2/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamUpperSuppViewController : UICollectionReusableView

@property (strong, nonatomic) IBOutlet UISlider *sliderForRadius;
- (IBAction)sliderDidMove:(id)sender;

@end

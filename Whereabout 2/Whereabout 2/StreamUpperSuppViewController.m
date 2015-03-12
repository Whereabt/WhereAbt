//
//  StreamUpperSuppViewControllerCollectionReusableView.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 2/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamUpperSuppViewController.h"
#import "StreamCollectionViewController.h"

@implementation StreamUpperSuppViewController

- (IBAction)sliderDidMove:(id)sender {
    StreamCollectionViewController *CollectionViewDelegate = [[StreamCollectionViewController alloc] init];
    
    //update the collection view
    [CollectionViewDelegate updateCollectionViewWithSliderValueChange: self.sliderForRadius.value];
}

@end

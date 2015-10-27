//
//  ProfileCollectionCollectionViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 2/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCollectionViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *userProfileActivityIndicator;

- (IBAction)profileRefreshButtonPress:(id)sender;
- (void)deleteEntryFromProfileItemsWithIndex:(NSIndexPath *)entryIndex;

@end

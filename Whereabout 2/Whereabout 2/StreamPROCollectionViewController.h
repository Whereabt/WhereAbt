//
//  StreamPROCollectionViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 3/25/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamPROCollectionViewController : UICollectionViewController

- (void)setUpProfileWithUserID:(NSString *) userId;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *profileActivityIndicator;

- (IBAction)streamPRORefreshButtonPress:(id)sender;


@end

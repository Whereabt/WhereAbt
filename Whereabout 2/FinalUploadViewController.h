//
//  FinalUploadViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza on 12/31/15.
//  Copyright © 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalUploadViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

- (void)setCollectionViewDataSourceFromThisArray:(NSArray *)filterList;
- (IBAction)uploadButtonPressed:(id)sender;

@end

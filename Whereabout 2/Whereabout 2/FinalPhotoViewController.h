//
//  FinalPhotoViewController.h
//  Pods
//
//  Created by Nicolas Isaza on 12/30/15.
//
//

#import <UIKit/UIKit.h>

@interface FinalPhotoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

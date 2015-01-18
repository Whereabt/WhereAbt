//
//  CollectionStreamViewControllerCollectionViewController.h
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StreamDelegate <NSObject>
- (void)recievedLocalStreamJSON:(NSData *)objectNotation;
- (void)gettingLocalStreamFailedWithError:(NSError *)error;

@end

typedef void (^RequestCompletionBlock)(BOOL finished);

@interface StreamCollectionViewController : UICollectionViewController
@property (weak,nonatomic) id<StreamDelegate> delegate;



@end

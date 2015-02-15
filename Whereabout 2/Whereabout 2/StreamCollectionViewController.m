//
//  CollectionStreamViewControllerCollectionViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/15/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamCollectionViewController.h"
#import "StreamController.h"
#import "StreamCollectionViewCell.h"
#import "DetailStreamViewController.h"

NSString *kCellID = @"cellID";

static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";


@interface StreamCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *streamItems;
@end


@implementation StreamCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass: [StreamCollectionViewCell class]forCellWithReuseIdentifier:kCellID];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flow];
    
    //create object to deal with network requests
   StreamController *networkRequester = [[StreamController alloc]init];
    
    //ADD Slider and change radius parameter to its value
    [networkRequester getFeedWithRadius:1 andCompletion:^(NSMutableArray *items, NSError *error) {
        if (!error) {
            self.streamItems = items;
            [self.collectionView reloadData];
        }
        
        else{
            NSLog(@"Error getting streamItems: %@", error);
            UIAlertView *streamFailAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"Sorry, we were unable to retrieve nearby photos from the server. Make sure that your phone is connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [streamFailAlert show];
        }
    }];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
   // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.streamItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   StreamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[StreamCollectionViewCell alloc]init];
    }
  
   // NSString *milesFrom = self.streamItems[indexPath.row][distanceFrom];
    //cell. = [NSString stringWithFormat:@"%@, Distance Away: %@", self.streamItems[indexPath.row][userIdIndex], milesFrom];
    
    //UIImage *imageReturned = [[UIImage alloc]initWithCIImage:self.streamItems[indexPath.row][@"ThumbnailPhoto"]];
   
    UIImage *imageReturned = self.streamItems[indexPath.row][@"ThumbnailPhoto"];
    
    cell.imageOfCell.image = imageReturned;
    [cell.imageOfCell sizeToFit];
    //cell.backgroundColor = [UIColor redColor];
    cell.labelOfCell.textColor = [UIColor blueColor];
    NSLog(@"Label text: %@", self.streamItems[indexPath.row][@"UserName"]);
    cell.labelOfCell.text = self.streamItems[indexPath.row][@"UserName"];
    UIView *cellView = [[UIView alloc] init];
    UIImageView *imageSubview = [[UIImageView alloc] initWithImage:imageReturned];
    [cellView addSubview: imageSubview];
    cell.backgroundView = cellView;
    
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

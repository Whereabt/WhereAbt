//
//  StreamViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 1/1/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "StreamViewController.h"
#import "StreamController.h"
#import "StreamDelegate.h"
#import "EnlargeViewController.h"

/*
static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";
*/

@interface StreamViewController ()


@property (strong, nonatomic) NSMutableArray *streamItems;

@end

@implementation StreamViewController


- (void)viewDidLoad {
     [super viewDidLoad];
    
    //create object to deal with network requests
    self.radiusSlider.continuous = NO;
    
    StreamController *networkRequester = [[StreamController alloc]init];
    [networkRequester getFeedWithRadius:self.radiusSlider.value andCompletion:^(NSMutableArray *items, NSError *error) {
        if (!error) {
            self.streamItems = items;
            [self.tableView reloadData];
        }
        
        else{
            NSLog(@"Error getting streamItems: %@", error);
        }
    }];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)userChangedRadius:(id)sender {
    StreamController *networkRequester = [[StreamController alloc]init];
    [networkRequester getFeedWithRadius:self.radiusSlider.value andCompletion:^(NSMutableArray *items, NSError *error) {
        if (!error) {
            self.streamItems = items;
            [self.tableView reloadData];
        }
        
        else{
            NSLog(@"Error getting streamItems: %@", error);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

                                  
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.streamItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"User ID" forIndexPath:indexPath];
    
    //setting UI
    //NSString *milesFrom = self.streamItems[indexPath.row][@"MilesAway"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.streamItems[indexPath.row][@"UserName"]];
    UIImage *photo = [[UIImage alloc]init];
    photo = self.streamItems[indexPath.row][@"ThumbnailPhoto"];
    cell.imageView.image = photo;
    
    /*
    UIButton * b = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f , cell.imageView.frame.size.width, cell.imageView.frame.size.height)];
    b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [b addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
    [cell.imageView addSubview:b];
    */
     
    return cell;
}


-(IBAction)changeSize:(UIButton *)sender
{
    UIImageView * imageView = (UIImageView *)[sender superview];
    imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    // larger frame goes here^
}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // UIViewController *SelectedCellViewController = [[UIViewController alloc]initWithNibName:@"Enlarged View" bundle:nil];
   // [self presentViewController:SelectedCellViewController animated:YES completion:nil];
    
    UIImage *enlargedPhoto = self.streamItems[indexPath.row][@"LargePhoto"];
    UIImageView *enlargeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
   
    enlargeView.image = enlargedPhoto;
    [self.view addSubview:enlargeView];
    
    //EnlargedCellViewController *enlargedCellManager = [[EnlargedCellViewController alloc]init];
    
    
    
    [enlargedCellManager setImageForEnlargedImageUsingImage:enlargedPhoto];
    [enlargedCellManager setTextForUsernameLabel:self.streamItems[indexPath.row][@"UserName"]];
    
    
    //enlargedCellManager.enlargedName.text = self.streamItems[indexPath.row][@"UserName"];
   // enlargedCellManager.enlargedImage.image = enlargedPhoto;
    //[self performSegueWithIdentifier:@"segueToEnlarge" sender:self];
}
*/



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
     

@end

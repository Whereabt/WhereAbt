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
#import "LocationController.h"
#import <CoreLocation/CoreLocation.h>

static NSString *const userIdIndex = @"UserID";
static NSString *const photoURLIndex = @"PhotoURL";
static NSString *const photoIndex = @"Photo";
static NSString *const distanceFrom = @"MilesAway";


@interface StreamViewController ()
{
    //NSMutableArray *itemCollection;
    NSMutableArray *StreamItems;
   // StreamLogic *logicManager;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation StreamViewController


- (void)viewDidLoad {
    //create object to deal with network requests
    StreamController *networkRequester = [[StreamController alloc]init];
    [networkRequester requestFeedWithClientLocation:[LocationController sharedController].currentLocation WithCompletion:^{
        [super viewDidLoad];
        [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*- (void)performRequestWithCompletion: (void (^)(void))callBackBlock{
    //create object to deal with network requests
    StreamController *networkRequester = [[StreamController alloc]init];
    
    //get location
    [networkRequester requestFeedWithClientLocation:[LocationController sharedController].currentLocation];
    callBackBlock();
}*/

- (void)setValueForStreamItemsWithValue:(NSMutableArray *)array{
    StreamItems = array;
}

/*
- (void) reloadTableView{
    [self.tableView reloadData];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)requestFeedWithClientLocation:(CLLocation*)location
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/feed.php?Latitude=%f&Longitude=%f", location.coordinate.latitude, location.coordinate.longitude];
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSURLSession *session = [NSURLSession sharedSession];
   
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error){
                NSError *jsonError = nil;
                NSArray *immutable = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError]; // handle response
                itemCollection = [immutable mutableCopy];
                NSLog(@"%@", itemCollection);
                for (NSDictionary *photoItem in itemCollection) {
                    NSString *photoURL = photoItem[photoURLIndex];
                    NSInteger photoItemIndex = [itemCollection indexOfObject:photoItem];
                   [self imageFromURLString:photoURL atIndex:photoItemIndex];
                }
                [self.tableView reloadData];
            }
       ];
     [dataRequestTask resume];
}

- (void)imageFromURLString:(NSString *)urlString atIndex: (NSInteger)index
{
    NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *photoRequestTask = [session dataTaskWithURL: url
            completionHandler: ^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error == nil) {
                    NSMutableDictionary *newDict = itemCollection[index];
                    UIImage *returnedImage = [UIImage imageWithData:data];
                    if (returnedImage != nil) {
                        [newDict setObject:returnedImage forKey:photoIndex];
                        [self.tableView reloadData];
                    }
                }
            }
      ];
    
    [photoRequestTask resume];
}

*/
                                  
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [StreamItems count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"User ID" forIndexPath:indexPath];
    
    //setting UI
    NSString *milesFrom = StreamItems[indexPath.row][distanceFrom];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, Distance Away: %@", StreamItems[indexPath.row][userIdIndex], milesFrom];
    cell.imageView.image = StreamItems[indexPath.row][photoIndex];

    return cell;
}


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

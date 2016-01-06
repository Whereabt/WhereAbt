//
//  StreamBlobTestViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/6/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

#import "StreamBlobTestViewController.h"
#import "ReadWriteBlobsManager.h"

@interface StreamBlobTestViewController ()

@end

@implementation StreamBlobTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ReadWriteBlobsManager *blobDownloadManager = [[ReadWriteBlobsManager alloc] init];
    
    NSUserDefaults *test = [NSUserDefaults standardUserDefaults];
    
    
    [blobDownloadManager downloadBlob:[test objectForKey:@"blobName"] fromContainer:[test objectForKey:@"containerName"] ToStringWithCompletion:^(NSString *dataString, NSError *cbError) {
        
        NSData *theData = [NSData dataWithBytes:(__bridge const void * _Nullable)(dataString)
                                         length:[dataString length]+1];
        
        
        const char *utfDataString = [dataString UTF8String];
        unsigned char *firstBuffer, secondBuffer[20];
        
        /* initialize data1, data2, and secondBuffer... */
        NSMutableData *imgData = [NSMutableData dataWithBytes:utfDataString length:strlen(utfDataString)+1];
        
        UIImage *img = [UIImage imageWithData:theData];
        [self.photo setImage:img];
    }];
    
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

@end

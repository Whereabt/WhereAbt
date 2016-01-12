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
    self.photo.contentMode = UIViewContentModeScaleAspectFit;
    ReadWriteBlobsManager *blobDownloadManager = [[ReadWriteBlobsManager alloc] init];
    
    NSUserDefaults *test = [NSUserDefaults standardUserDefaults];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 30, 30)];
    [self.photo addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [blobDownloadManager downloadBlob:[test objectForKey:@"blobName"] fromContainer:[test objectForKey:@"containerName"] ToStringWithCompletion:^(NSString *dataString, NSError *cbError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:dataString
                                                              options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *img = [UIImage imageWithData:data];
            [activityIndicator removeFromSuperview];
            [self.photo setImage:img];
            
        });
        
        
        /* initialize data1, data2, and secondBuffer... */
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

//
//  PhotosAccessViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 12/20/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import "PhotosAccessViewController.h"
#import "StreamViewController.h"
#import "LocationController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <CoreLocation/CoreLocation.h>

//static NSString *const fakeFileName = @"Fake2.jpg";

@interface PhotosAccessViewController ()
@property (strong, nonatomic) NSString* uploadURL;
@property (strong, nonatomic) NSString* authToken;
@property (assign) BOOL sourceTypeCamera;
@property (strong, nonatomic) NSString *metaLong;
@property (strong, nonatomic) NSString *metaLat;
@property (strong, nonatomic) NSString *PUTUrlString;

@end

@implementation PhotosAccessViewController


- (void)viewDidLoad {
    self.uploadURL = @"https://api.onedrive.com/v1.0/drive/root:/Whereabt/%@:/content";
    [LocationController sharedController];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}



//implementing UseCameraRoll action method
- (IBAction)useCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = NO;
    }
    
    else{
        UIAlertView *noCameraRollAlert = [[UIAlertView alloc]initWithTitle:@"Problem Occurred" message:@"We were unable to access your camera roll" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noCameraRollAlert show];
    }
}

//implementing useCamera action method
- (IBAction)useCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.showsCameraControls = YES;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
    else{
        UIAlertView *noCameraAlert = [[UIAlertView alloc]initWithTitle:@"Problem Occurred" message:@"It appears that your device doesn't have a camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noCameraAlert show];
    }

}



#pragma mark - UIImagePickerControllerDelegate

//responding to user accepting image/video he just took
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    //determining image source
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _sourceTypeCamera = YES;
        
         //get location
         LocationController *locationController = [LocationController sharedController];
        _metaLong = [NSString stringWithFormat: @"%f", locationController.currentLocation.coordinate.longitude];
        _metaLat = [NSString stringWithFormat: @"%f", locationController.currentLocation.coordinate.latitude];
        NSLog(@"Client longitude: %@ latitude: %@", _metaLong, _metaLat);
    }
         
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        _sourceTypeCamera = NO;
        NSURL *assetURL = info [@"UIImagePickerControllerReferenceURL"];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            NSDictionary *metadata = asset.defaultRepresentation.metadata;
            if (metadata) {
               CLLocation *imageLocation = metadata[ALAssetPropertyLocation];
                _metaLong = [NSString stringWithFormat:@"%f", imageLocation.coordinate.longitude];
                _metaLat = [NSString stringWithFormat:@"%f", imageLocation.coordinate.latitude];
            }
        }failureBlock:^(NSError *error) {
            //user denied access
            NSLog(@"Unable to access image metadata: %@", error);
        }];
        
    }
    
    //handling image taken
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:
                UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                    UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        }
        else {
            imageToSave = originalImage;
        }
        
        //convert image to data
        NSData *dataFromImage = UIImagePNGRepresentation(imageToSave);
        
        NSURL *imageFileURL = [info objectForKey:imageToSave];
        NSString *imageFileName = [imageFileURL lastPathComponent];
        NSLog(@"the name of the image file is: %@", imageFileName);
        NSString *fakeFileName = @"Fake2.jpg";
        
        self.authToken = @"EwCAAq1DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAAZVdbu98AUcgW6UabKE4LZT05zRPjaHElJONTbwn1fMIXfKXnOzkok1uwKRnYHoB6QtFcPlC6nL7dM6DCvLwLYP5G2Jo0jKkMcfnArHK5ch/hBwMNCcvcm4YRaviSo08EmK7pIsXtxHh188sPsBdQAE1HGiBuhXBBtssoi/1IIbTWTJr4W+QY9AUO5l6RNKuwS/kU0r5VPk0wLTeQ7XeHiFFq+7A+0m/5oFKV5HjFTCaRMtpMUcsneumm2o+CvbY64mhLL67DNDYSf7pY/9Nb9q5Im1zRN3387GAcl/L6BZmHoWWo+a8oCmExhe/78WPD7i3RgED7wW8m63keaZU0aoDZgAACNUKzP1oK9g7UAECJbiFtubjKNpT7wsPA1gRLQhkYd8YD7aKlww984965eBlXRh/0sReDCtPPAK+eQtKCxVIhe/AIcYdWhxeLb8HWvYUjB+fsJml/McDmaGyvNqxMNLezwM0Qfd+wxZ8dW589w7RvwTevHyCM+ouvBwyta8ozDYuZ1zTvsrpNxkQ1vy3v5gt1cleG11RsEkV77TwMT6zq8TSl6ICOCzWz8dUsNa3KAsFAJmpsgkKgMqxbTrmcRK6e8J7gFBfpqt0dELWzbAgbItL02kgUKoiiE19O+vmPYP07OQbicalVnNku00TdVf1RxDWIzsxhgx14yC17bHUAGi5swBoktwcQJWSGwZXAigdon9JlQNo9bF1xAkxEoCESBTe8RzDSLaTO8MQIN1T+djE8fTwo+t38SVRiDFVt3+xd5RQeK1RBJVUCr4SoA80EUOGgptyfW73Gc9iAQ==";
        
        [self constructTaskWithImageName:fakeFileName andData: dataFromImage];
        //method call for http request
       //[self PUTImageToOD:imageFileName imageWithData:dataFromImage];
        
    }
    
    //handling video taken;
    else if (CFStringCompare((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo){
        NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
            //movieURL will be passed as parameter to server
    }

    //the animated camera view is dismissed
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

//user presses cancel button in UIImagePickerView
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)constructTaskWithImageName:(NSString*)name andData:(NSData*)data{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *stringURL = [NSString stringWithFormat:self.uploadURL, name];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.authToken]forHTTPHeaderField: @"Authorization"];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
            if (error == nil){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
               NSString *publicImage = httpResponse.allHeaderFields[@"Location"];
                
                [self PUTonNewPhotophpWithImageURL:publicImage];
            }
    }];
    [uploadTask resume];
}


- (void)PUTonNewPhotophpWithImageURL:(NSString *)ODimageUrl{
    NSString *userID = @"Lucas";
    
    if (self.sourceTypeCamera == YES) {
        _PUTUrlString = [NSString stringWithFormat:@"https://n46.org/whereabt/newphoto.php?UserID=%@&Latitude=%@&Longitude=%@&PhotoURL=%@", userID, _metaLat, _metaLong, ODimageUrl];
        NSLog(@"%@", _PUTUrlString);
    }
    else{
        //do something
    }
    
    NSURL *url = [[NSURL alloc]initWithString:_PUTUrlString];
    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error){

                                                       
                }];
    [dataRequestTask resume];
}


/*
- (void)uploadToNewPhotoPHPWithUserID:(NSString *)userID Latitude:(NSInteger)lat Longitude:(NSInteger)lon Photo:(NSURL*)photoURL TimeStamp:(NSDate*)photoTime{
    NSString *urlString = [[NSString alloc]init];
    urlString = @"https://n46.org/whereabt/newphoto.php?UserID=%f&Latitude=%f&Longitude=%f&PhotoURL=%f",userID,lat,lon,photoURL,photoTime;
    NSURL *newPhotoURL = [[NSURL alloc]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //setting up url request
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL: newPhotoURL
            completionHandler: ^(NSData *data,
                                 NSURLResponse *response,
                                 NSError *error) {
                if (error == nil) {
                    NSLog(@"Data returned from newPhoto.php request: %@", data);
                    
                }
              }]resume];
    
}
*/
 
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

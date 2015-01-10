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
#import <CoreLocation/CoreLocation.h>

//static NSString *const fakeFileName = @"Fake2.jpg";

@interface PhotosAccessViewController ()
@property (strong, nonatomic) NSString* uploadURL;
@property (strong, nonatomic) NSString* authToken;

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
        
        self.authToken = @"EwCAAq1DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAAWM1SSVIt7UdBVAMfU0EfiGsQbuHerPh0S8sVWE48WZLeOO9wvVKY4w7Tp8Ul3IA8ledn//cBhTjXUIo1PHHDp4/xj7ECXK6VeE+nrKUU663cgMQkSnt+jiinGW1x5uwjLp6QS+YfX/1iAmByNSwCRgdku0HQ+d+2cmfJ98HiouWd4n8CzY9t7XORm3tBsjRTJqWY2ponS29dMFd8Ys/Sl8Dk1sZxESRpJHz/OK6OnYLx6krNir12svfSbJuebeHWTmycfAgEzQ+jefUx+i5h7ZEylnYi8kLyW8RjkZt6AyOS1NOgSZS7sqcbK/YprwgtDJ3F2JbAOKp3dDmWS4EUm0DZgAACK+JnvJtq2COUAHtfWQVuYHppFJkFI3JvJTleOWiz+agoCTl/0tQ6VE6CcXsa5JzX73ptAxG/Qrz5rWpVm0F98MhMcVFKVYv7o1wJd9QKGT8/znLjS3c4d4ArOG5MtzdpAvMaYBjqLeWY38mI5w3ZXK4JK9Kr/HOFWCKwIw2z/hJqWo5X91nNwGDCEsjfzgiwJRyKtmyxd4TeFYmQPMcADISKW8CNfXiSu0BPSVKLiitNmtmEVJEs5UiqxTSexzoMy+AhlJqRz5rAdxxf65cDplY7EszK5VxhXMfRNFSNuDsw35jkj1zpbKkyORAmKTd82Fz4aQ0rsllqiejnLmkxzyeFcU/9KN0K9jMvLM+HmYULoo2ELNM8Rroe+cfVBpgJXa4vF/6+zYE20Hm9dXCpsuPSNMML9Feq/ngh17KzSoW07RJAnXQSdB9Z59AkUeM3UXQingUpWUlUTBiAQ==";
        
        [self constructTaskWithImageName:fakeFileName andData: dataFromImage];
        //method call for http request
       //[self PUTImageToOD:imageFileName imageWithData:dataFromImage];
        
    }
    
    //handling video taken;
    else{
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
    NSString *userID = @"NicolasIsaza";
    
    //get location
    LocationController *locationController = [LocationController sharedController];
   CLLocation *thisLocation = locationController.currentLocation;
    NSString *urlAsString = [NSString stringWithFormat:@"https://n46.org/whereabt/newphoto.php?UserID=%@&Latitude=%f&Longitude=%f&PhotoURL=%@", userID, thisLocation.coordinate.latitude, thisLocation.coordinate.longitude, ODimageUrl];
    
    NSURL *url = [[NSURL alloc]initWithString:urlAsString];
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

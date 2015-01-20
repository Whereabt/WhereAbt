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
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
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
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //maybe decide to temporarily only allow images, not images and videos
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
  /*
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
  */
    
    self.authToken = @"EwBwAq1DBAAUGCCXc8wU/zFu9QnLdZXy%2bYnElFkAAeKuWRh2Dh0CHu2aTDQpw36iUa17swWyhpEBB29nlEXY3DzTxpDXO2V3uUvZsDxRWJ0/t7Zj4F0i1gkI%2bfdiIaYHbD96fzYXoUBGf6MVKK1lIZOZMvPm43ZvTJ9FA9xk3aqsavyJpzM%2bfeYixXlSTuQcaCfYwl9xt1DGrW94lBSmQr9Mgj3bPPzgDvf6tmlphS7Vujg9qouYn4JF4beDsv9p0T3%2bJU%2bN5w6N4RLnuIAEfsXE/ZmDha51L5U%2bCeP7jQKofg9uduU9/x6689nR4g2rbCDuegPUStELwq7sDpvrbYiHVNZLxr7zbsVvWQo/5G2aL2TVIYinQ/Tj9lq0O0EDZgAACLY0oBDZHXRdQAGwJDVB7/2Rw8UavB6DrXxN6b20BpqbxPQOgHWFZ8uC%2bk7zzBPV7GUhrGcYK4%2batzpyFUr96RWCRMhVwra60i8UKpsJ/c92GCMgk8gPapOMb0lRLAtCp7FH4FeEj7/l0ydHdFoYF3rJLtZMXLaSJACVVxtsVytFcz6BneHksRbbGBmXJrjR427wJ6sIf34jVyc9u3unNGJomjAO2jLp3PxqtJhk533C6sHsSm1gzB3V46szJP7pnKQbJPlffQbh4FgrTfQccyHFnSyJDRC83E5FKc7i%2bTd7ygF4MPhFfIsNTQS27Axt5QO0JXDBvPQ6oyM7gv/QjMkngNRoCSFjj1QoReUreKU/pVOftlgcfrVtQ3yLfO7TGV/ZNHAiIRKBjylf8hF%2bPxgQGLMhIHJtcf6l88xufEhHqhUxSoykwAYPEFoB&authentication_token=eyJhbGciOiJIUzI1NiIsImtpZCI6IjEiLCJ0eXAiOiJKV1QifQ.eyJ2ZXIiOjEsImlzcyI6InVybjp3aW5kb3dzOmxpdmVpZCIsImV4cCI6MTQyMTcyMTQ2MCwidWlkIjoiOTI1ODVlZjU1NTdjNzkwOGFiOWEyYmMyMjE3M2EwNmYiLCJhdWQiOiJuNDYub3JnIiwidXJuOm1pY3Jvc29mdDphcHB1cmkiOiJhcHBpZDovLzAwMDAwMDAwNEMxMzQ5NkUiLCJ1cm46bWljcm9zb2Z0OmFwcGlkIjoiMDAwMDAwMDA0QzEzNDk2RSJ9.7dpcoJ47TIH6XoczvfurbO-QkXbeh60cw9mUl-hoWvM&token_type=bearer&expires_in=3600&scope=wl.skydrive_update&user_id=92585ef5557c7908ab9a2bc22173a06f";
  
    //determining image source
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _sourceTypeCamera = YES;
        
         //get location
        LocationController *locationController = [[LocationController alloc]init];
    
        _metaLong = [NSString stringWithFormat: @"%f", locationController.locationManager.location.coordinate.longitude];
        _metaLat = [NSString stringWithFormat: @"%f", locationController.locationManager.location.coordinate.latitude];
        NSLog(@"Client longitude: %@ latitude: %@", _metaLong, _metaLat);
        
        //handling image taken
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        //declaring images
        UIImage *originalImage, *editedImage, *imageToSave;
        
        if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
            editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
            originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
            
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
            
            //make request to server
            [self constructTaskWithImageName:fakeFileName andData: dataFromImage];
            
        }
        
        //handling video taken;
        else {
            //movieURL will be passed as parameter to server
            UIAlertView *noMovieSupport = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"We currently don't support video uploads" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [noMovieSupport show];
        }
        
    }

    else{
        _sourceTypeCamera = NO;
        
        //fetching image metadata
        NSURL *assetURL = info [@"UIImagePickerControllerReferenceURL"];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            NSDictionary *metadata = asset.defaultRepresentation.metadata;
            if (metadata) {
                
                //getting GPS dictionary from metadata and then getting lat and lon. Eventually add "TimeStamp" and "DateStamp" as keys like lat. and lon.
                NSNumber *latitude = [[metadata objectForKey: @"{GPS}"] objectForKey:@"Latitude"];
                NSNumber *longitude = [[metadata objectForKey:@"{GPS}"] objectForKey:@"Longitude"];
                NSConstantString *latRef = [[metadata objectForKey:@"{GPS}"] objectForKey:@"LatitudeRef"];
                NSConstantString *lonRef = [[metadata objectForKey:@"{GPS}"] objectForKey:@"LongitudeRef"];
                
                
                if ([latRef isEqualToString:@"S"] == YES) {
                    _metaLat = [NSString stringWithFormat:@"-%@", latitude];
                }
                else //([latRef compare:@"N"] == YES)
                {
                    _metaLat = [NSString stringWithFormat:@"%@", latitude];
                }
                
                
                if ([lonRef isEqualToString: @"W"] == YES) {
                    _metaLong = [NSString stringWithFormat:@"-%@", longitude];
                }
                else //if([lonRef compare:@"E"] == YES)
                {
                    _metaLong = [NSString stringWithFormat:@"%@", longitude];
                }
                
                if ([_metaLong isEqualToString:@"(null)"] == YES || [_metaLat isEqualToString:@"(null)"] == YES) {
                    UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [metaAlert show];
                }
                
                else{
            
                
                    //handling image taken
                    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
                
                    //declaring images
                    UIImage *originalImage, *editedImage, *imageToSave;
                
                    //making sure only photos are uploaded, currently no videos
                    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
                        editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
                        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
                    
                        if (editedImage) {
                                imageToSave = editedImage;
                            }
                        else {
                                imageToSave = originalImage;
                        }
                                //convert image to data
                                NSData *dataFromImage = UIImagePNGRepresentation(imageToSave);
                    
                                //NSURL *imageFileURL = [info objectForKey:imageToSave];
                                NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
                                NSString *imageFileName = [imageFileURL lastPathComponent];
                                NSLog(@"the name of the image file is: %@", imageFileName);
                                NSString *fakeFileName = @"Fake2.jpg";
                    
                                [self constructTaskWithImageName:fakeFileName andData: dataFromImage];
                                //method call for http request
                                //[self PUTImageToOD:imageFileName imageWithData:dataFromImage];
                    
                    }
                    
                    else {
                        //movieURL will be passed as parameter to server
                        UIAlertView *noMovieSupport = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"We currently don't allow videos to be uploaded" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [noMovieSupport show];

                    }
                
                }
            }
            //no metadata found
        else{
                UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [metaAlert show];
            }
        } failureBlock:^(NSError *error) {
            
            //metadata is nil
            NSLog(@"Unable to access image metadata: %@", error);
            UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [metaAlert show];
        }];
 
    }
  
   /*
    //handling image taken
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
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
        
        self.authToken = @"EwCAAq1DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAATuAZi+aibAaL06FhFU4mqv+P2ra0N7bedyZEoeGhuRm8sWpefnj9RvVpk/hH3XhwggTcPdX4cV5zpDEYclR0dC2KV+7l5Zo9b1YOd0teNbD3/hhCiqz5BKckl0cCUEPepdOj0seOuyap44gmvSHkLoOrcD0XWlYOD4EcGgpnPWEroMwx2qXIev2fBwGjoAHCwcqGK6EndT1cBdx55As8K4lxqwfN3DVy3AzEI098mXyLcs2C5RYl8bTCLbdSi1wNa7pZUTnUQ7NGG6W7dFwrp81zntChvu9yK/mLs9mQIuAXfG0NRLn7ECRrk0vc/EG2je7HU3pkmWqUr2ElTXhljsDZgAACK1On/KOwyALUAFMdJuHzIkUpJS6EelMTgc5wfCp9FcKfVT5+XITrUieemfal+whEx+FLJnpZJAMgLgcmGarV6dx1YMDJPSuH9uaAjXpY8ipZSC1IxHRdZe3j41yyN05Z7UHdp4Uov9G8oVKVT+FegSPRdZ8QM3gAvOWzHzAeJLUXdFJrL3nlDEQx5MWfji4LRWHYYFGCz6LGsp6j6idVWELHRJUWtutQoKEio98ppEXCjg34XVLoN0ire2Ypwp2k3CogGMbR4+DfBOeC8vtgXMWoyxOKxsl/4O6kXAgGg+1KtIPha3TNC2yzY0/P1h2DC+LvpztLZRJ8Gwdb5KpD6sSsoPMGB2k8arJkzZ4rDf2vfjzA0qLJwGek/huTrC3w/xLyYpq2blgJerYdd9nrcB2WwjYOSKJ1KZa2SyPj4I4J3FgfbS3HJjOMlA/Apwl7q1d3jOnuFUWeMRiAQ==";
        
        [self constructTaskWithImageName:fakeFileName andData: dataFromImage];
        //method call for http request
       //[self PUTImageToOD:imageFileName imageWithData:dataFromImage];
        
    }
    
    //handling video taken;
    else if (CFStringCompare((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo){
        NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
            //movieURL will be passed as parameter to server
    }
*/
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
    if (_metaLong != nil) {
    
        _PUTUrlString = [NSString stringWithFormat:@"https://n46.org/whereabt/newphoto.php?UserID=%@&Latitude=%@&Longitude=%@&PhotoURL=%@", userID, _metaLat, _metaLong, ODimageUrl];
        NSLog(@"%@", _PUTUrlString);
    
    NSURL *url = [[NSURL alloc]initWithString:_PUTUrlString];
    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error){
                                                       if (error) {
                                                           NSLog(@"Error: %@",error);
                                                       }
                                                       else{
                                                           NSLog(@"PUT to newPhoto.php completed");
                                                       }

                                                       
                }];
    [dataRequestTask resume];
    }
    else{
        UIAlertView *PhotoLocationAlert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We were unable to find the photo's location, please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [PhotoLocationAlert show];
    }
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

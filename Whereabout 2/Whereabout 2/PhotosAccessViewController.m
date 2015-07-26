//
//  PhotosAccessViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 12/20/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import "PhotosAccessViewController.h"
#import "OverlayView.h"
#import "WelcomeViewController.h"
#import "StreamViewController.h"
#import "LocationController.h"
#import "NSNetworkConnection.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <CoreLocation/CoreLocation.h>
#include <math.h>


//static NSString *const fakeFileName = @"Fake2.jpg";

@interface PhotosAccessViewController ()
@property (strong, nonatomic) NSString* uploadURL;
@property (assign) BOOL sourceTypeCamera;
@property (strong, nonatomic) NSString *metaLong;
@property (strong, nonatomic) NSString *metaLat;
@property (strong, nonatomic) NSDate *metaTimeStamp;
@property (strong, nonatomic) NSString *PUTUrlString;
@property (strong, nonatomic) NSMutableDictionary *postInfo;
@property (nonatomic, assign) BOOL hasLoadedVC;
@property (nonatomic, assign) BOOL wantsCamera;

@end

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412

//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

UIImagePickerController *imagePicker;

@implementation PhotosAccessViewController

{
    WelcomeViewController *welcomeManager;
    NSString *uniqueFileName;
    UIViewController *VC;
}

- (void)viewDidLoad {
    self.uploadURL = @"https://api.onedrive.com/v1.0/drive/root:/%@:/content";

    [LocationController sharedController];
    
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //present camera
    
    if (self.hasLoadedVC == NO) {
        
        if (self.wantsCamera) {
        
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
                imagePicker = [[UIImagePickerController alloc]init];
        
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //default mediaType propoerty value is only type images so no need to specify
        //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //make NO if using overlay
                imagePicker.showsCameraControls = NO;
        
                OverlayView *overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
                imagePicker.cameraOverlayView = overlay;
                imagePicker.view.alpha = 1.0;
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                imagePicker.toolbarHidden = YES;
                imagePicker.navigationBarHidden = YES;
                imagePicker.delegate = self;
            //imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
                imagePicker.navigationBar.barStyle = UIBarStyleDefault;
        
                imagePicker.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f
                                                              green:153.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f];
        
                _newMedia = YES;
                [imagePicker setAllowsEditing:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
    
            else {
                UIAlertView *noCameraAlert = [[UIAlertView alloc]initWithTitle:@"Problem Occurred" message:@"It appears that your device doesn't have a camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [noCameraAlert show];
            }
        }
        
        else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
                imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                //default mediaType propoerty value is only type images so no need to specify
                //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                imagePicker.allowsEditing = YES;
                _newMedia = NO;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
            else {
                UIAlertView *noCameraRollAlert = [[UIAlertView alloc]initWithTitle:@"Problem Occurred" message:@"We were unable to access your camera roll" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [noCameraRollAlert show];
            }

        }
        self.hasLoadedVC = YES;
    }
    
    else {
        //remove the vc, go to stream
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)setSourceTypeToWantsCamera:(BOOL) wantsCameraBool {
    self.wantsCamera = wantsCameraBool;
}

- (void)createShareLinkForODFileWithPath:(NSString *) ODfilePath andCompletion: (void (^)(NSError *Error))theCallback {
    
    NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/root:/%@:/action.createLink", ODfilePath];
    //NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/items/%@/action.createLink", ODfilePath];

    NSURL *url = [NSURL URLWithString:stringURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSLog(@"UPLOAD_TOKEN: %@", [WelcomeViewController sharedController].authToken);
    
    //auth header
    [request addValue:[NSString stringWithFormat:@"Bearer %@", [WelcomeViewController sharedController].authToken] forHTTPHeaderField: @"Authorization"];
    
    //content type header
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableDictionary *requestBodyDict = [[NSMutableDictionary alloc] init];
    [requestBodyDict setObject:@"edit" forKey:@"type"];
    
    NSString *StringJSONbody = [self jsonStringFromDictionary:requestBodyDict];

    if (StringJSONbody != nil) {
        
        NSData *DataJSONbody = [StringJSONbody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        [request setHTTPBody:DataJSONbody];
        
        //make task
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSLog(@"Share link data, not json: %@", data);
            
            NSError *jsonError = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

            if (!jsonError && !error) {
                NSLog(@"JSON from returned data (share link):%@", jsonDict);
                NSString *unencodedShareURL = jsonDict[@"link"][@"webUrl"];
                
                //must double-encode the url
                /*
                NSString *singleEncodedShareURL = [unencodedShareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString *doubleEncodedShareURL = [singleEncodedShareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"Single encoded url: %@, Double encoded share url:%@, Unencoded shareURL: %@", singleEncodedShareURL, doubleEncodedShareURL, unencodedShareURL);
                */
                
                NSString *singleEncodedShareURL = [unencodedShareURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                
                NSString *doubleEncodedShareURL = [singleEncodedShareURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                
                NSString *encString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (CFStringRef)unencodedShareURL,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8 ));
                /* encString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                  NULL,
                                                                                                  (CFStringRef)encString,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8 ));
                                                        
                 */
                 
                NSLog(@"Single encoded url: %@, Double encoded share url:%@, Unencoded shareURL: %@, Other URL: %@", singleEncodedShareURL, doubleEncodedShareURL, unencodedShareURL, url);
                
                //make request
                NSString *theUrlAsString = @"https://api.onedrive.com/v1.0/shares/";
                
                NSURL *firstURL = [NSURL URLWithString:theUrlAsString];
                NSURL *properURL = [firstURL URLByAppendingPathComponent:singleEncodedShareURL];
                
                NSURL *encURL = [firstURL URLByAppendingPathComponent:encString];
                
                NSLog(@"Double encoded url from share link: %@", properURL);
                NSURLSession *theSession = [NSURLSession sharedSession];
                
                NSURLRequest *theRequest = [NSURLRequest requestWithURL:encURL];
                NSLog(@"REQUEST: %@", theRequest);
                NSURLSessionDataTask *dataRequestTask = [theSession dataTaskWithRequest:theRequest completionHandler:^(NSData *theData, NSURLResponse *theResponse, NSError *theError) {
                    NSLog(@"Response from encoded url data request task: %@   Error: %@", theResponse, theError);
                    NSError *jsonerror = nil;
                    NSArray *immutable = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonerror];
                    NSLog(@"JSON from double encoded url request: %@", immutable);
                    
                    theCallback(theError);
                }];
                
                
                /*
                NSURLSessionDataTask *dataRequestTask = [theSession dataTaskWithURL:properURL completionHandler:^(NSData *theData, NSURLResponse *theResponse, NSError *theError) {
                    NSLog(@"Response from encoded url data request task: %@   Error: %@", theResponse, theError);
                    NSError *jsonerror = nil;
                    NSArray *immutable = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonerror];
                    NSLog(@"JSON from double encoded url request: %@", immutable);
                    theCallback(theError);
                }];*/
                [dataRequestTask resume];
                
            }
            
            else {
                
                UIAlertView *jsonOrDataTaskAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a problem while trying to connect to the server, please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [jsonOrDataTaskAlert show];
                
                NSLog(@"Error in making public folder:%@", jsonError);
            }

        }];
        [postDataTask resume];
        
    }
    
    else {
        NSLog(@"Error creating request body's JSON");
        
        UIAlertView *requestBodyJsonAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a problem while trying to connect to the server, please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [requestBodyJsonAlert show];
        
    }
}

- (NSString *)jsonStringFromDictionary:(NSMutableDictionary *) dictToTranslate {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictToTranslate
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"Got an error in converting data to json string: %@", error);
        jsonString = nil;
    }
    
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}


//OVERLAY BUTTONS
- (void)takePhotoFromCamera {
    [imagePicker takePicture];
}

- (void)cancelTakePhotoEvent {
    StreamViewController *streamController = [[StreamViewController alloc] init];
    
    [streamController closePhotoVCWithCompletion:^{
        //[imagePicker dismissViewControllerAnimated:YES completion: nil];
    }];
}

- (void)switchCamera {
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    }
    else {
        [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    }
    
}

- (void)selectFromCameraRoll {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self createImagePickerForCameraRoll];
       }];
}

- (void)createImagePickerForCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        UIImagePickerController *rollPicker = [[UIImagePickerController alloc]init];
        rollPicker.delegate = self;
        rollPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //default mediaType propoerty value is only type images so no need to specify
        //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        rollPicker.allowsEditing = YES;
        _newMedia = NO;
        
        NSLog(@"Last VC: %@", [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]);
        [self presentViewController:rollPicker animated:YES completion:nil];
    }
    
    else{
        UIAlertView *noCameraRollAlert = [[UIAlertView alloc]initWithTitle:@"Problem Occurred" message:@"We were unable to access your camera roll" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noCameraRollAlert show];
    }
}

#pragma mark - UIImagePickerControllerDelegate

//responding to user accepting image/video he just took
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (_newMedia == YES) {
        NSLog(@"From camera");
        
        //set post stuff
        imagePicker = picker;
        self.postInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        
        UIImage *originalImage = [info objectForKey: UIImagePickerControllerOriginalImage];
        UIImage *finalImage;
        if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
            finalImage = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationLeftMirrored];
        }
        else {
            finalImage = originalImage;
        }
        
        UIImageView *PreviewImageView = [[UIImageView alloc] initWithImage:finalImage];
        PreviewImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 430);
        //PreviewImageView.contentMode = UIViewContentModeScaleAspectFill;
        PreviewImageView.opaque = YES;
        PreviewImageView.userInteractionEnabled = YES;
        VC = [[UIViewController alloc] init];
        [VC.view addSubview:PreviewImageView];
        //VC.view = PreviewImageView;
        
        [self.postInfo setObject:finalImage forKey:UIImagePickerControllerOriginalImage];
        
        
        
        
        //create post button
        UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2), 533, (self.view.frame.size.width/2) - 5, 35)];
        [postButton setTitle:@"POST" forState:UIControlStateNormal];
        [postButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f
                                                  green:153.0f/255.0f
                                                   blue:255.0f/255.0f
                                                  alpha:1.0f] forState:UIControlStateNormal];
        
        postButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [postButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [postButton addTarget:self action:@selector(postButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [VC.view addSubview:postButton];
        
        NSLog(@"Button width: %f", (self.view.frame.size.width/2) - 5);
        
        // create cancel button
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 533, (self.view.frame.size.width/2) - 5, 35)];
        [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [cancelButton setTitleColor: [UIColor colorWithRed:0.0f/255.0f
                                                              green:153.0f/255.0f
                                                               blue:255.0f/255.0f
                                                              alpha:1.0f] forState:UIControlStateNormal];
        
        cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [cancelButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [cancelButton addTarget:self action: @selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [VC.view addSubview:cancelButton];
        
        [picker presentViewController:VC animated:NO completion:nil];
    }

    else {
        StreamViewController *streamVC = [[StreamViewController alloc] init];
        [streamVC setUploadingPhotoVarTo:YES];
        [self userFinishedEditingImageWithPicker:picker andInfo:info];
        NSLog(@"From camera roll");

    }
    
}

- (void)postButtonPressed {
    
    StreamViewController *streamVC = [[StreamViewController alloc] init];
    if ([streamVC uploadingPhoto]) {
        
        UIAlertView *tooManyUploadsAlert = [[UIAlertView alloc] initWithTitle:@"Still Uploading" message:@"Please wait until your last photo finishes uploading." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [tooManyUploadsAlert show];
    }
    
    else {
        [streamVC setUploadingPhotoVarTo:YES];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        if ([[preferences objectForKey:@"autoSave"] isEqualToString:@"YES"]) {
            UIImage *imageFromInfo = [self.postInfo objectForKey:UIImagePickerControllerOriginalImage];
            
            UIImage *imageForSave = [[UIImage alloc] initWithCIImage:imageFromInfo.CIImage scale:imageFromInfo.scale orientation:imageFromInfo.imageOrientation];
            
            UIImageWriteToSavedPhotosAlbum(imageForSave, nil, nil, nil);
        }

        [imagePicker dismissViewControllerAnimated:YES completion:^{
            [self userFinishedEditingImageWithPicker:imagePicker andInfo:self.postInfo];
        }];
    }
}

- (void)cancelButtonPressed {
    [VC dismissViewControllerAnimated:YES completion:nil];
}

- (void)userFinishedEditingImageWithPicker:(UIImagePickerController *)thePicker andInfo:(NSDictionary *)imageInfo {
    //CHECK CONNECTION BEFORE ANYTHING
    NSNetworkConnection *NetworkManager = [[NSNetworkConnection alloc] init];
    if ([NetworkManager doesUserHaveInternetConnection]) {
        
        
        //determining image source
        if (thePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            _sourceTypeCamera = YES;
            NSLog(@"IMAGE INFO: %@", imageInfo);
            
            //get location
            LocationController *locationController = [[LocationController alloc]init];
            
            _metaLong = [NSString stringWithFormat: @"%f", locationController.locationManager.location.coordinate.longitude];
            _metaLat = [NSString stringWithFormat: @"%f", locationController.locationManager.location.coordinate.latitude];
            NSLog(@"Client longitude: %@ latitude: %@", _metaLong, _metaLat);
            
            //handling image taken
            NSString *mediaType = [imageInfo objectForKey:UIImagePickerControllerMediaType];
            
            //declaring images
            UIImage *originalImage, *editedImage, *imageToSave;
            
            if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
                editedImage = (UIImage *) [imageInfo objectForKey: UIImagePickerControllerEditedImage];
                originalImage = (UIImage *) [imageInfo objectForKey: UIImagePickerControllerOriginalImage];
                
                if (editedImage) {
                    imageToSave = editedImage;
                }
                else {
                    imageToSave = originalImage;
                }
                
                //convert image to data
                NSData *dataFromImage = UIImagePNGRepresentation(imageToSave);
                
                
                //set unique file name
                NSString *processedName = [[NSProcessInfo processInfo] globallyUniqueString];
                uniqueFileName = [NSString stringWithFormat:@"%@.jpg", processedName];
                
                //make request to server
                [self constructTaskWithImageName:uniqueFileName andData: dataFromImage];
                
            }
            
            //handling video taken;
            else {
                //movieURL will be passed as parameter to server
                UIAlertView *noMovieSupport = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"We currently don't support video uploads" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [noMovieSupport show];
            }
            
        }
        
        else {
            _sourceTypeCamera = NO;
            
            //fetching image metadata
            NSURL *assetURL = imageInfo [@"UIImagePickerControllerReferenceURL"];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                NSDictionary *metadata = asset.defaultRepresentation.metadata;
                if (metadata) {
                    
                    //getting GPS dictionary from metadata and then getting lat and lon. Eventually add "TimeStamp" and "DateStamp" as keys like lat. and lon.
                    NSNumber *latitude = [[metadata objectForKey: @"{GPS}"] objectForKey:@"Latitude"];
                    NSNumber *longitude = [[metadata objectForKey:@"{GPS}"] objectForKey:@"Longitude"];
                    NSConstantString *latRef = [[metadata objectForKey:@"{GPS}"] objectForKey:@"LatitudeRef"];
                    NSConstantString *lonRef = [[metadata objectForKey:@"{GPS}"] objectForKey:@"LongitudeRef"];
                    NSDate *metaDateStamp = metadata[@"{GPS}"][@"DateStamp"];
                    //NSString *metaTimeStamp = metadata[@"{GPS}"][@"]
                    
                    NSString *date = [metadata[@"{GPS}"][@"DateStamp"] stringByReplacingOccurrencesOfString: @":" withString:@"-"];
                    
                    NSString *metaDateString = [NSString stringWithFormat:@"%@T%@", date, metadata[@"{GPS}"][@"TimeStamp"]];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                    
                    _metaTimeStamp = [dateFormat dateFromString:metaDateString];
                    NSLog(@"Date found in metadata: %@",_metaTimeStamp);
                    NSLog(@"%@", metadata);
                    
                    
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
                        UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [metaAlert show];
                    }
                    
                    else{
                        
                        //handling image taken
                        NSString *mediaType = [imageInfo objectForKey:UIImagePickerControllerMediaType];
                        
                        //declaring images
                        UIImage *originalImage, *editedImage, *imageToSave;
                        
                        //making sure only photos are uploaded, currently no videos
                        if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
                            editedImage = (UIImage *) [imageInfo objectForKey: UIImagePickerControllerEditedImage];
                            originalImage = (UIImage *) [imageInfo objectForKey: UIImagePickerControllerOriginalImage];
                            
                            if (editedImage) {
                                imageToSave = editedImage;
                            }
                            else {
                                imageToSave = originalImage;
                            }
                            //check defaults
                            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                            
                            if ([[preferences objectForKey:@"autoSave"] isEqualToString:@"YES"]) {
                                UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
                            }
                            //otherwise, is set to nil or "NO"
                            
                            //convert image to data
                            NSData *dataFromImage = UIImagePNGRepresentation(imageToSave);
                            
                            //NSURL *imageFileURL = [info objectForKey:imageToSave];
                            NSURL *imageFileURL = [imageInfo objectForKey:UIImagePickerControllerReferenceURL];
                            NSString *imageFileName = [imageFileURL lastPathComponent];
                            NSLog(@"the name of the image file is: %@", imageFileName);
                            
                            //unique file name so as to not replace it with future photo upload
                            NSString *processedName = [[NSProcessInfo processInfo]globallyUniqueString];
                            uniqueFileName = [NSString stringWithFormat:@"%@.jpg", processedName];
                            
                            [self constructTaskWithImageName:uniqueFileName andData: dataFromImage];
                            //method call for http request
                            //[self PUTImageToOD:imageFileName imageWithData:dataFromImage];
                            
                        }
                        
                        else {
                            //movieURL will be passed as parameter to server
                            UIAlertView *noMovieSupport = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"We currently don't allow videos to be uploaded" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [noMovieSupport show];
                            
                        }
                        
                    }
                    
                    [thePicker dismissViewControllerAnimated:YES completion:NULL];
                }
                //no metadata found
                else {
                    [thePicker dismissViewControllerAnimated:YES completion:NULL];

                    UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [metaAlert show];
                }
            } failureBlock:^(NSError *error) {
                
                NSLog(@"Unable to access image metadata: %@", error);
                UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [metaAlert show];
            }];
            
        }
        
        [thePicker dismissViewControllerAnimated:YES completion:NULL];
    }
    
    else {
        NSLog(@"NO CONNECTION");
        [thePicker dismissViewControllerAnimated:YES completion:NULL];
        UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"We were unable to post your photo." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alertCont addAction:okAction];
        
        [self presentViewController:alertCont animated:YES completion:nil];
    }
    
}


//user presses cancel button in UIImagePickerView
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)constructTaskWithImageName:(NSString*)name andData:(NSData*)data {
    
    NSString *filePath = [NSString stringWithFormat:@"Whereabt.Test2/%@", name];
            NSURLSession *session = [NSURLSession sharedSession];
            NSString *stringURL = [NSString stringWithFormat:self.uploadURL, filePath];
            
            //NSString *stringURL = [NSString stringWithFormat:self.uploadURL, [NSString stringWithFormat:@"%@", name]];
            
            NSURL *url = [NSURL URLWithString:stringURL];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
            [request setHTTPMethod:@"PUT"];
            
            //referencing auth singleton
            [request addValue:[NSString stringWithFormat:@"Bearer %@", [WelcomeViewController sharedController].authToken] forHTTPHeaderField: @"Authorization"];
            NSLog(@"UPLOAD_TOKEN: %@", [WelcomeViewController sharedController].authToken);
    
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
                if (error == nil) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    //url of main image file (not thumbnail)
                    NSString *publicImage = httpResponse.allHeaderFields[@"Location"];
                    
                    NSError *jsonError = nil;
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    NSLog(@"RESPONSE FROM OD UPLOAD: %@", jsonDict);
                    NSString *resourceId = jsonDict[@"id"];
                    

                    //@"Whereabt.Test2"
                    [self createShareLinkForODFileWithPath:filePath andCompletion:^(NSError *Error) {
                        
                        if (!Error) {
                            
                            //[self getThumbnailURLfromStoredImageFile:[NSString stringWithFormat:@"%@/%@", folderPath, name] andCompletion
                            [self getThumbnailURLfromStoredImageFile:resourceId andCompletion:^(NSString *thumbnail, NSString *large) {
                                if (thumbnail != nil & large != nil) {
                                    NSLog(@"The thumbnail URL: %@ ---- The large URL: %@", thumbnail, large);
                                    
                                    //using fullsize for 'large image', substitute 'large'  for 'publicImage' to change to large thumbnail
                                    [self PUTonNewPhotophpWithImageURLsLarge:large andSmall:thumbnail];
                                }
                                else {
                                    NSLog(@"Failed to get a thumbnail URL");
                                    UIAlertView *thumbnailAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a network error while trying to send your photo to the server. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                    [thumbnailAlert show];
                                }
                            }];
                        }
                        else {
                            UIAlertView *publicFolderAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a network error while trying to send your photo to the server. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [publicFolderAlert show];
                        }
                    }];
                    
                }
            }];
    [uploadTask resume];
}


- (void)getThumbnailURLfromStoredImageFile:(NSString *)fileName andCompletion: (void (^)(NSString *thumbnail, NSString *large))callBack{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/items/%@/thumbnails", fileName];
    
    NSURL *url = [NSURL URLWithString:stringURL];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@", [WelcomeViewController sharedController].authToken] forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL: url
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error){
        
        NSError *jsonError = nil;
        NSArray *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"Dictionary from THUMBNAIL RESPONSE: %@", responseDict);
        
        //pass small and large size images
        /*
        NSDictionary *bothDict = [responseDict objectAtIndex:1];
        NSLog(@"%@", bothDict);
        NSArray *bothArray = bothDict[@"value"];
        NSArray *bothArrayTwo = bothArray[0];
        NSDictionary *largeDictOne = bothArrayTwo[0];
        NSArray *largeArrayOne = largeDictOne[@"large"];
        NSDictionary *largeDictTwo = largeArrayOne[0];
        
        NSDictionary *smallDictOne = bothArray[0];
        NSArray *smallArrayOne = smallDictOne[@"small"];
        NSDictionary *smallDictTwo = smallArrayOne[0];
         */
        
        NSString *stringResponse = [NSString stringWithFormat:@"%@", responseDict];
        NSString *withoutEnter = [stringResponse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *withoutSpaces = [withoutEnter stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *fixedStringREsponse = [withoutSpaces stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"%@", fixedStringREsponse);
        NSArray *largeAll = [fixedStringREsponse componentsSeparatedByString:@";large="];
        NSLog(@"%@", largeAll);
        NSString *largeAllString = largeAll[1];
        NSArray *largeItemsMore = [largeAllString componentsSeparatedByString:@";medium="];
        NSString *largeItemString = largeItemsMore[0];
        NSArray *beforeUrl = [largeItemString componentsSeparatedByString:@";url="];
        NSString *stringAfterUrl = beforeUrl[1];
        NSArray *urlMore = [stringAfterUrl componentsSeparatedByString:@";width="];
        NSString *largeImageUrl = urlMore[0];
        
        NSArray *mediumSmall = [fixedStringREsponse componentsSeparatedByString:@"};medium="];
        NSString *mediumSmallString = mediumSmall[1];
        
        NSArray *smallOnly = [fixedStringREsponse componentsSeparatedByString:@"};small="];
        NSString *smallOnlyString = smallOnly[1];
        NSArray *beforeSmallUrl = [smallOnlyString componentsSeparatedByString:@";url="];
        NSString *stringAfterSmallUrl = beforeSmallUrl[1];
        NSArray *SmallUrlMore = [stringAfterSmallUrl componentsSeparatedByString:@";width"];
        NSString *smallImageUrl = SmallUrlMore[0];
        
        
        
        callBack(smallImageUrl, largeImageUrl);
    }];
    
    [dataTask resume];
    /*
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSLog(@"Response: %@", response);
    }];
    
    NSURLSessionDataTask *thumbnailTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *thumbnailDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSString *urlToThumbnail = [thumbnailDict objectForKey:@"url"];
        callBack(urlToThumbnail);
    }];
    [thumbnailTask resume];
     */
}


- (void)PUTonNewPhotophpWithImageURLsLarge:(NSString *)largeImage andSmall:(NSString *) smallImage{
    if (_metaLong != nil & _metaLat != nil) {
        
        if (!_metaTimeStamp) {
            _metaTimeStamp = [NSDate date];
            NSLog(@"Today's date, as string: %@", _metaTimeStamp);
        }

        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSString *dateString = [dateFormatter stringFromDate: _metaTimeStamp];

        _PUTUrlString = [NSString stringWithFormat:@"https://n46.org/whereabt/newphoto2.php?UserID=%@&UserName=%@&Latitude=%@&Longitude=%@&PhotoURL=%@&ThumbnailURL=%@&TimeStamp=%@", [WelcomeViewController sharedController].userID, [WelcomeViewController sharedController].userName, _metaLat, _metaLong, largeImage, smallImage, dateString];
        NSLog(@"PUT URL String: %@", _PUTUrlString);
    
    NSURL *url = [[NSURL alloc]initWithString:_PUTUrlString];
    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataRequestTask = [session dataTaskWithURL: url
                                                   completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error){
                                                       
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        StreamViewController *streamController = [[StreamViewController alloc] init];
                                                        [streamController stopRefreshControlOnPhotoUpload];
                                                                        
                                                       });
                                                       
                                                       if (error) {
                                                           NSLog(@"ERROR: %@", error);
                                                           UIAlertView *PhotoPUTAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"An error occurred, please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                           [PhotoPUTAlert show];

                                                       }
                                                       else{
                                                           NSLog(@"PUT to newPhoto.php completed");
                                                       }
                                                       
                }];
    [dataRequestTask resume];
    }
    else{
        UIAlertView *PhotoLocationAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"We were unable to find the photo's location." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [PhotoLocationAlert show];
    }
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

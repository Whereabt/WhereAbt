//
//  PhotosAccessViewController.m
//  Whereabout 2
//
//  Created by Nicolas on 12/20/14.
//  Copyright (c) 2014 Nicolas Isaza. All rights reserved.
//

#import "PhotosAccessViewController.h"
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

@end

@implementation PhotosAccessViewController

{
    WelcomeViewController *welcomeManager;
    NSString *uniqueFileName;
}

- (void)viewDidLoad {
    self.uploadURL = @"https://api.onedrive.com/v1.0/drive/root:/%@:/content";

    [LocationController sharedController];
    
    self.uploadActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.uploadActivityIndicator.color = [UIColor orangeColor];
    self.uploadActivityIndicator.hidesWhenStopped = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)stopAnimatingActivityIndicator {
    if ([self.uploadActivityIndicator isAnimating]) {
        [self.uploadActivityIndicator stopAnimating];
    }

}

- (void)createShareLinkForODFileWithPath:(NSString *) ODfilePath andCompletion: (void (^)(NSError *Error))theCallback {
    
    //NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/root:/%@:/action.createLink", ODfilePath];
    NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/items/%@/action.createLink", ODfilePath];

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
                
                NSString *singleEncodedShareURL = [unencodedShareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *doubleEncodedShareURL = [singleEncodedShareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"double encoded share url:%@", doubleEncodedShareURL);
                
                //make request
                NSString *theUrlAsString = @"https://api.onedrive.com/v1.0/shares/";
                
                NSURL *firstURL = [NSURL URLWithString:theUrlAsString];
                NSURL *properURL = [firstURL URLByAppendingPathComponent:doubleEncodedShareURL];
                                 
                NSLog(@"Double encoded url from share link: %@", properURL);
                NSURLSession *theSession = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataRequestTask = [theSession dataTaskWithURL:properURL completionHandler:^(NSData *theData, NSURLResponse *theResponse, NSError *theError) {
                    NSLog(@"Response from encoded url data request task: %@   Error: %@", theResponse, theError);
                    theCallback(theError);
                }];
                [dataRequestTask resume];
                
            }
            
            else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.uploadActivityIndicator isAnimating] == YES) {
                        [self.uploadActivityIndicator stopAnimating];
                    }
                });
                
                UIAlertView *jsonOrDataTaskAlert = [[UIAlertView alloc] initWithTitle:@"Problem Occurred" message:@"We encountered a problem while trying to connect to the server, please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [jsonOrDataTaskAlert show];
                
                NSLog(@"Error in making public folder:%@", jsonError);
            }

        }];
        [postDataTask resume];
        
    }
    
    else {
        NSLog(@"Error creating request body's JSON");
        
        if ([self.uploadActivityIndicator isAnimating] == YES) {
            [self.uploadActivityIndicator stopAnimating];
        }
        
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


//implementing UseCameraRoll action method
- (IBAction)fromCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //default mediaType propoerty value is only type images so no need to specify
        //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
- (IBAction)fromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //default mediaType propoerty value is only type images so no need to specify
        //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
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
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//CHECK CONNECTION BEFORE ANYTHING
NSNetworkConnection *NetworkManager = [[NSNetworkConnection alloc] init];
if ([NetworkManager doesUserHaveInternetConnection]) {

    //determining image source
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _sourceTypeCamera = YES;
        if (![self.uploadActivityIndicator isAnimating]) {
            [self.uploadActivityIndicator startAnimating];
        }
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
            
                    if (![self.uploadActivityIndicator isAnimating]) {
                        [self.uploadActivityIndicator startAnimating];
                    }
                    
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
                                //check defaults
                        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                        
                        if ([[preferences objectForKey:@"autoSave"] isEqualToString:@"YES"]) {
                            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
                        }
                        //otherwise, is set to nil or "NO"
                        
                                //convert image to data
                                NSData *dataFromImage = UIImagePNGRepresentation(imageToSave);
                    
                                //NSURL *imageFileURL = [info objectForKey:imageToSave];
                                NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
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
                        if ([self.uploadActivityIndicator isAnimating]) {
                            [self.uploadActivityIndicator stopAnimating];
                        }
                        //movieURL will be passed as parameter to server
                        UIAlertView *noMovieSupport = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"We currently don't allow videos to be uploaded" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [noMovieSupport show];

                    }
                
                }
                
                [picker dismissViewControllerAnimated:YES completion:NULL];
                
                /* if (![self.uploadActivityIndicator isAnimating]) {
                    [self.uploadActivityIndicator startAnimating];
                }
                 */
            }
            //no metadata found
        else {
                [picker dismissViewControllerAnimated:YES completion:NULL];
            if ([self.uploadActivityIndicator isAnimating]) {
                [self.uploadActivityIndicator stopAnimating];
            }
                UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [metaAlert show];
            }
        } failureBlock:^(NSError *error) {
            
            //metadata is nil
            if ([self.uploadActivityIndicator isAnimating]) {
                [self.uploadActivityIndicator stopAnimating];
            }
            NSLog(@"Unable to access image metadata: %@", error);
            UIAlertView *metaAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You may only upload photos from your camera roll if they have a location stored in their metadata" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [metaAlert show];
        }];
 
    }
  
    [picker dismissViewControllerAnimated:YES completion:NULL];
  }
    
else {
    NSLog(@"NO CONNECTION");
    UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"We were unable to post your photo." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:okAction];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self presentViewController:alertCont animated:YES completion:nil];
  }
    
}


//user presses cancel button in UIImagePickerView
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)createSubfolderInODWithName:(NSString *)folderName andCompletion: (void (^)(bool subfolderErrorBool))subfolderCallback {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *stringURL = [NSString stringWithFormat:@"https://api.onedrive.com/v1.0/drive/special/approot/children"];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    bodyDict[@"name"] = [NSString stringWithFormat:@"%@", folderName];
    //bodyDict[@"folder"] = @"";
    bodyDict[@"@name.conflictBehavior"] = @"fail";
    
    NSString *jsonBodyString = [self jsonStringFromDictionary:bodyDict];
    NSLog(@"Request body json: %@", jsonBodyString);

    NSData *DataJSONbody = [jsonBodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:DataJSONbody];
        
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    //referencing auth singleton
    [request addValue:[NSString stringWithFormat:@"Bearer %@", [WelcomeViewController sharedController].authToken] forHTTPHeaderField: @"Authorization"];
    
    NSLog(@"UPLOAD_TOKEN: %@", [WelcomeViewController sharedController].authToken);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL errorBool;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (error || [httpResponse statusCode] == 403) {
            NSLog(@"ERROR in request to create subfolder: %@", error);
            errorBool = YES;
        }
            
        else {
            NSError *jsonError = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                errorBool = YES;
            }
            else {
                NSLog(@"RESPONSE: %@", response);
                NSLog(@"Returned json from POST: %@", jsonDict);
            }
        }
        
        subfolderCallback(errorBool);
    }];
    
    [postDataTask resume];
   
}

- (void)constructTaskWithImageName:(NSString*)name andData:(NSData*)data {
    NSString *filePath = [NSString stringWithFormat:@"Whereabout_Public/%@", name];
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
                    
                    [self createShareLinkForODFileWithPath:resourceId andCompletion:^(NSError *Error) {
                        
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
                                                           //self.uploadActivityIndicator.hidden = YES;
                                                           [self.uploadActivityIndicator stopAnimating];
                                                           //[self.uploadActivityIndicator removeFromSuperview];
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

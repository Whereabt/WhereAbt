//
//  ReadWriteBlobsManager.m
//  
//
//  Created by Nicolas Isaza on 1/4/16.
//
//

#import "ReadWriteBlobsManager.h"
#import <UIKit/UIKit.h>
#import <Azure_Storage_Client_Library.h>

@implementation ReadWriteBlobsManager

-(void)createContainerFromName:(NSString *)containerName {
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=whereaboutcloud;AccountKey=iOZUM4RA1UfOKje24cz/VgkoQnSUR6UBg9ZpEFwOCnX8rJRjpCJuV3kpBybaGiLyfnGHBQqs4eN9bsAAOAm7SA=="];
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:containerName];
    
    // Create container in your Storage account if the container doesn't already exist
    [blobContainer createContainerIfNotExistsWithCompletionHandler:^(NSError *error, BOOL exists) {
        if (error){
            NSLog(@"Error in creating container.");
        }
    }];
}

-(void)uploadBlobToContainerWithPhotoDict:(NSMutableDictionary *)blobInfo WithCompletion:(void (^)(NSError *cbError))callBack{
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=whereaboutcloud;AccountKey=iOZUM4RA1UfOKje24cz/VgkoQnSUR6UBg9ZpEFwOCnX8rJRjpCJuV3kpBybaGiLyfnGHBQqs4eN9bsAAOAm7SA=="];
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:blobInfo[@"UserID"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:blobInfo[@"UserID"] forKey:@"containerName"];
    [defaults setObject:blobInfo[@"PhotoID"] forKey:@"blobName"];
    
    [blobContainer createContainerIfNotExistsWithAccessType:AZSContainerPublicAccessTypeContainer requestOptions:nil operationContext:nil completionHandler:^(NSError *error, BOOL exists)
     {
         if (error){
             NSLog(@"Error in creating container.");
         }
         else{
             // Create a local blob object
             AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:blobInfo[@"PhotoID"]];
             
             // Upload blob to Storage
             [blockBlob uploadFromText:blobInfo[@"Data-String"] completionHandler:^(NSError *error) {
                 callBack(error);
             }];
         }
     }];
}

-(void)downloadBlob:(NSString *)blobName fromContainer:(NSString *)containerName ToStringWithCompletion:(void (^)(NSString *dataString, NSError *cbError))callBack{
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=whereaboutcloud;AccountKey=iOZUM4RA1UfOKje24cz/VgkoQnSUR6UBg9ZpEFwOCnX8rJRjpCJuV3kpBybaGiLyfnGHBQqs4eN9bsAAOAm7SA=="];
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:containerName];
    
    // Create a local blob object
    AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:blobName];
    
    // Download blob
    [blockBlob downloadToTextWithCompletionHandler:^(NSError *error, NSString *text) {
        callBack(text, error);
    }];
}

@end

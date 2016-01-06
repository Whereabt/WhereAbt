//
//  ReadWriteBlobsManager.h
//  
//
//  Created by Nicolas Isaza on 1/4/16.
//
//

#import <Foundation/Foundation.h>

@interface ReadWriteBlobsManager : NSObject
-(void)uploadBlobToContainerWithPhotoDict:(NSMutableDictionary *)blobInfo WithCompletion:(void (^)(NSError *cbError))callBack;
-(void)downloadBlob:(NSString *)blobName fromContainer:(NSString *)containerName ToStringWithCompletion:(void (^)(NSString *dataString, NSError *cbError))callBack;

@end

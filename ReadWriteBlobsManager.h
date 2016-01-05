//
//  ReadWriteBlobsManager.h
//  
//
//  Created by Nicolas Isaza on 1/4/16.
//
//

#import <Foundation/Foundation.h>

@interface ReadWriteBlobsManager : NSObject
-(void)uploadBlobToContainerWithPhotoDict:(NSMutableDictionary *)blobInfo;

@end

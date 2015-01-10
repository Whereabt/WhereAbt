//
//  StreamDelegate.h
//  Whereabout 2
//
//  Created by Lucas Isaza on 1/4/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StreamDelegate <NSObject>
- (void)recievedLocalStreamJSON:(NSData *)objectNotation;
- (void)gettingLocalStreamFailedWithError:(NSError *)error;

@end

//
//  NSNetworkConnection.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 5/24/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "NSNetworkConnection.h"

@import SystemConfiguration;

@implementation NSNetworkConnection

- (BOOL)doesUserHaveInternetConnection {
    SCNetworkReachabilityFlags flags;
 	BOOL receivedFlags;

 	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"google.com" UTF8String]);
 	receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
 	CFRelease(reachability);

 	//NSLog(@"idiotic flags %@", receivedFlags);

 	if (!receivedFlags || (flags == 0))
 	{
     		return NO;
    }
    else {
         		return YES;
        	}
}

@end

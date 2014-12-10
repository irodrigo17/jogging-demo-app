//
//  NSError+AFNetworking.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/10/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "NSError+AFNetworking.h"

@implementation NSError (AFNetworking)

- (BOOL)isNetworkError
{
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorNotConnectedToInternet;
}

@end

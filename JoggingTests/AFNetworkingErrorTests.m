//
//  AFNetworkingErrorTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/13/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSError+AFNetworking.h"


@interface AFNetworkingErrorTests : XCTestCase

@end

@implementation AFNetworkingErrorTests

- (void)testIsNetworkError
{
    NSError *error = nil;
    XCTAssert(![error isNetworkError]);
    
    error = [NSError errorWithDomain:@"Domain" code:-1 userInfo:nil];
    XCTAssert(![error isNetworkError]);
    
    error = [NSError errorWithDomain:@"Domain" code:-1 userInfo:nil];
    XCTAssert(![error isNetworkError]);
    
    error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
    XCTAssert([error isNetworkError]);
}

@end

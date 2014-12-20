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
#import <AFNetworking/AFURLResponseSerialization.h>


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

- (void)testHTTPStatus
{
    NSError *error = nil;
    XCTAssert(![error HTTPStatus]);
    
    error = [NSError errorWithDomain:@"Domain" code:-1 userInfo:nil];
    XCTAssert(![error HTTPStatus]);
    
    NSInteger status = 404;
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:status HTTPVersion:nil headerFields:nil];
    NSDictionary *userInfo = @{AFNetworkingOperationFailingURLResponseErrorKey: response};
    error = [NSError errorWithDomain:@"Domain" code:-1 userInfo:userInfo];
    XCTAssert([error HTTPStatus] == status);
}

@end

//
//  APIManagerTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "APIManager.h"


@interface APIManagerTests : XCTestCase

@end

@implementation APIManagerTests

- (void)testSharedInstance
{
    APIManager *sharedInstance = [APIManager sharedInstance];
    XCTAssert(sharedInstance == [APIManager sharedInstance]);
    
    XCTAssert([sharedInstance.baseURL isEqual:[NSURL URLWithString:@"https://api.parse.com/1/"]]);
    
    XCTAssert([sharedInstance.requestSerializer isKindOfClass:[AFJSONRequestSerializer class]]);
    NSString *appIdHeader = [sharedInstance.requestSerializer valueForHTTPHeaderField:@"X-Parse-Application-Id"];
    XCTAssert([appIdHeader isEqual:@"miw8ufMpwGjfvnuLssMXMNs0xNqThjWDRKJC2ELl"]);
    NSString *apiKeyHeader = [sharedInstance.requestSerializer valueForHTTPHeaderField:@"X-Parse-REST-API-Key"];
    XCTAssert([apiKeyHeader isEqual:@"fCtvn92JEjCElNM1kfGIicIB3AvP5lO7pLUIznLv"]);
    NSString *contentTypeHeader = [sharedInstance.requestSerializer valueForHTTPHeaderField:@"Content-Type"];
    XCTAssert([contentTypeHeader isEqual:@"application/json"]);
    NSString *acceptHeader = [sharedInstance.requestSerializer valueForHTTPHeaderField:@"Accept"];
    XCTAssert([acceptHeader isEqual:@"application/json"]);
    
    XCTAssert([sharedInstance.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]);
}

@end

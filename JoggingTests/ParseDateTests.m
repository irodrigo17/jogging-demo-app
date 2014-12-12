//
//  DateHelperTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <ISO8601/ISO8601.h>
#import "NSDate+Parse.h"


@interface ParseDateTests : XCTestCase

@end

@implementation ParseDateTests

- (void)testDateSerialization
{
    NSDate *date = nil;
    NSDictionary *parseDate = [date parseDictionary];
    XCTAssert(parseDate == nil);
    
    date = [NSDate date];
    parseDate = [date parseDictionary];
    XCTAssert(parseDate != nil);
    XCTAssert([parseDate[@"__type"] isEqualToString:@"Date"]);
    XCTAssert([parseDate[@"iso"] isEqualToString:[date ISO8601String]]);
}

- (void)testDateDeserialization
{
    XCTAssert([NSDate dateWithParseDictionary:nil] == nil);
    
    XCTAssert([NSDate dateWithParseDictionary:@{}] == nil);
    
    NSDictionary *parseDate = @{
        @"__type": @"Date",
        @"iso": @"2011-08-21T18:02:52.249Z"
    };
    XCTAssert([NSDate dateWithParseDictionary:parseDate] != nil);
}

@end

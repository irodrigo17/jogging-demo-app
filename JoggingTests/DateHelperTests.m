//
//  DateHelperTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateHelper.h"
#import <ISO8601/ISO8601.h>


@interface DateHelperTests : XCTestCase

@end

@implementation DateHelperTests

- (void)testDateSerialization
{
    NSDictionary *parseDate = [DateHelper serializeParseDate:nil];
    XCTAssert(parseDate == nil);
    
    NSDate *date = [NSDate date];
    parseDate = [DateHelper serializeParseDate:date];
    XCTAssert(parseDate != nil);
    XCTAssert([parseDate[@"__type"] isEqualToString:@"Date"]);
    XCTAssert([parseDate[@"iso"] isEqualToString:[date ISO8601String]]);
}

- (void)testDateDeserialization
{
    XCTAssert([DateHelper deserializeParseDate:nil] == nil);
    
    XCTAssert([DateHelper deserializeParseDate:@{}] == nil);
    
    NSDictionary *parseDate = @{
        @"__type": @"Date",
        @"iso": @"2011-08-21T18:02:52.249Z"
    };
    XCTAssert([DateHelper deserializeParseDate:parseDate] != nil);
}

@end

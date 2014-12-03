//
//  JogTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "Jog.h"


@interface JogTests : XCTestCase

@end


@implementation JogTests

- (void)testDistanceInKm
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([jog distanceInKm] == 0.0f, @"Distance should be 0 km");
    jog.distance = @(1);
    XCTAssert([jog distanceInKm] == 0.001f, @"Distance should be 0.001 km");
    jog.distance = @(500);
    XCTAssert([jog distanceInKm] == 0.5f, @"Distance should be 0.5 km");
    jog.distance = @(1000);
    XCTAssert([jog distanceInKm] == 1.0f, @"Distance should be 1.0 km");
    jog.distance = @(123456);
    XCTAssert([jog distanceInKm] == 123.456f, @"Distance should be 123.456 km");
}

- (void)testFormattedTime
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([[jog formattedTime] isEqual:@"00:00"], @"Time should be 00:00");
    jog.time = @(1);
    XCTAssert([[jog formattedTime] isEqual:@"00:01"], @"Time should be 00:01");
    jog.time = @(25);
    XCTAssert([[jog formattedTime] isEqual:@"00:25"], @"Time should be 00:01");
    jog.time = @(60);
    XCTAssert([[jog formattedTime] isEqual:@"01:00"], @"Time should be 00:01");
    jog.time = @(20*60 + 34);
    XCTAssert([[jog formattedTime] isEqual:@"20:34"], @"Time should be 20:34");
    jog.time = @(1*60*60 + 23*60 + 45);
    XCTAssert([[jog formattedTime] isEqual:@"1:23:45"], @"Time should be 1:23:45");
}

- (void)testFormattedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    
    Jog *jog = [[Jog alloc] init];
    XCTAssert([[jog formattedDate] isEqual:@""], @"Date should be ''");
    jog.date = [NSDate date];
    NSString *expectedDate = [formatter stringFromDate:jog.date];
    XCTAssert([[jog formattedDate] isEqual:expectedDate], @"Date should be %@", expectedDate);
}

- (void)testFormattedTimeAndDistance
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([[jog formattedTimeAndDistance] isEqual:@"0.00 km in 00:00"]);
    jog.distance = @(1234);
    jog.time = @(5*60 + 55);
    XCTAssert([[jog formattedTimeAndDistance] isEqual:@"1.23 km in 05:55"]);
}

@end

//
//  JogTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "Jog.h"
#import <ISO8601/ISO8601.h>


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

- (void)testDescription
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([[jog description] isEqual:@"0.00 km in 00:00, 0.00 km/h avg"]);
    jog.distance = @(1234);
    jog.time = @(5*60 + 55);
    XCTAssert([[jog description] isEqual:@"1.23 km in 05:55, 12.51 km/h avg"]);
}

- (void)testAverageSpeed
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([jog averageSpeed] == 0.0f);
    jog.distance = @(12000);
    XCTAssert([jog averageSpeed] == 0.0f);
    jog.time = @(30*60);
    XCTAssert([jog averageSpeed] == 24.0f);
}

- (void)testFormattedAverageSpeed
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([[jog formattedAverageSpeed] isEqual:@"0.00 km/h"]);
    jog.distance = @(1000);
    jog.time = @(5*60);
    XCTAssert([[jog formattedAverageSpeed] isEqual:@"12.00 km/h"]);
}

- (void)testUpdateWithDictionary
{
    Jog *jog = [[Jog alloc] init];
    
    [jog updateWithDictionary:nil];
    XCTAssert(!jog.distance);
    XCTAssert(!jog.time);
    XCTAssert(!jog.date);
    XCTAssert(!jog.objectId);
    XCTAssert(!jog.userId);
    
    [jog updateWithDictionary:@{}];
    XCTAssert(!jog.distance);
    XCTAssert(!jog.time);
    XCTAssert(!jog.date);
    XCTAssert(!jog.objectId);
    XCTAssert(!jog.userId);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1417624238];
    NSString *formattedDate = [date ISO8601String];
    NSDictionary *dateDic = @{@"__type": @"Date", @"iso": formattedDate};
    NSDictionary *userDic = @{@"__type": @"Pointer", @"class": @"_User", @"objectId": @"my-user-id"};
    NSDictionary *dic = @{@"distance": @(1), @"time": @(2), @"date": dateDic, @"objectId": @"my_id", @"user": userDic};
    [jog updateWithDictionary:dic];
    XCTAssert([jog.distance isEqual:dic[@"distance"]]);
    XCTAssert([jog.time isEqual:dic[@"time"]]);
    XCTAssert([jog.date isEqual:date]);
    XCTAssert([jog.objectId isEqual:dic[@"objectId"]]);
    XCTAssert([jog.userId isEqual:dic[@"user"][@"objectId"]]);

    [jog updateWithDictionary:@{}];
    XCTAssert([jog.distance isEqual:dic[@"distance"]]);
    XCTAssert([jog.time isEqual:dic[@"time"]]);
    XCTAssert([jog.date isEqual:date]);
    XCTAssert([jog.objectId isEqual:dic[@"objectId"]]);
    XCTAssert([jog.userId isEqual:dic[@"user"][@"objectId"]]);
    
    NSDictionary *badDic = @{@"distance": @"This should be a number instead of a string"};
    XCTAssert([jog.distance isEqual:dic[@"distance"]]);
    
    badDic = @{@"time": @"This should be a number instead of a string"};
    XCTAssert([jog.time isEqual:dic[@"time"]]);
    
    badDic = @{@"date": @(1)};
    XCTAssert([jog.date isEqual:date]);
    
    badDic = @{@"objectId": @(1)};
    XCTAssert([jog.objectId isEqual:dic[@"objectId"]]);
    
    badDic = @{@"user": @(1)};
    XCTAssert([jog.userId isEqual:dic[@"user"][@"objectId"]]);
    
}

- (void)testDictionary
{
    Jog *jog = [[Jog alloc] init];
    XCTAssert([[jog dictionary] isEqual:@{}]);
    
    jog.distance = @(1);
    jog.time = @(1);
    jog.date = [NSDate date];
    jog.objectId = @"my_id";
    jog.userId = @"my-user-id";
    
    NSString *date = [jog.date ISO8601String];
    NSDictionary *dateDic = @{@"__type": @"Date", @"iso": date};
    NSDictionary *userDic = @{@"__type": @"Pointer", @"class": @"_User", @"objectId": jog.userId};
    NSDictionary *expectedDic = @{@"distance": jog.distance, @"time": jog.time, @"date": dateDic, @"objectId": jog.objectId, @"user": userDic};
    XCTAssert([[jog dictionary] isEqual:expectedDic]);
}

@end

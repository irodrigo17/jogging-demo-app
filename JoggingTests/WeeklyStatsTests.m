//
//  WeeklyStatsTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/13/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WeeklyStats.h"
#import "NSDate+Parse.h"


@interface WeeklyStatsTests : XCTestCase

@end

@implementation WeeklyStatsTests


- (void)testFormattedDates
{
    WeeklyStats *stats = [WeeklyStats new];
    XCTAssert([stats formattedDates] == nil);
    
    stats.startDate = [NSDate date];
    XCTAssert([stats formattedDates] == nil);
    
    stats.startDate = nil;
    stats.endDate = [NSDate date];
    XCTAssert([stats formattedDates] == nil);
    
    stats.startDate = [NSDate date];
    stats.endDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    NSString *expectedString = [NSString stringWithFormat:@"From %@ to %@", [dateFormatter stringFromDate:stats.startDate], [dateFormatter stringFromDate:stats.endDate]];
    XCTAssert([[stats formattedDates] isEqualToString:expectedString]);
    
    
}

- (void)testFormattedAverageTime
{
    WeeklyStats *stats = [WeeklyStats new];
    XCTAssert([stats formattedAverageTime] == nil);
    
    stats.time = @(0);
    XCTAssert([stats formattedAverageTime] == nil);
    
    stats.jogs = @(0);
    stats.time = nil;
    XCTAssert([stats formattedAverageTime] == nil);
    
    stats.time = @(0);
    stats.jogs = (0);
    XCTAssert([stats formattedAverageTime] == nil);
    
    stats.time = @(0);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageTime] isEqualToString:@"0 min"]);
    
    stats.time = @(59);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageTime] isEqualToString:@"0 min"]);
    
    stats.time = @(60);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageTime] isEqualToString:@"1 min"]);
    
    stats.time = @(119);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageTime] isEqualToString:@"1 min"]);
    
    stats.time = @(140 * 60);
    stats.jogs = @(2);
    XCTAssert([[stats formattedAverageTime] isEqualToString:@"70 min"]);
    
    stats.time = @(142 * 60);
    stats.jogs = @(2);
    XCTAssert([[stats formattedAverageTime] isEqualToString:@"71 min"]);
}

- (void)testFormattedAverageDistance
{
    WeeklyStats *stats = [WeeklyStats new];
    XCTAssert([stats formattedAverageDistance] == nil);
    
    stats.distance = @(0);
    XCTAssert([stats formattedAverageDistance] == nil);
    
    stats.distance = @(0);
    stats.jogs = @(0);
    XCTAssert([stats formattedAverageDistance] == nil);
    
    stats.distance = @(0);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageDistance] isEqualToString:@"0.00 km"]);
    
    stats.distance = @(990);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageDistance] isEqualToString:@"0.99 km"]);
    
    stats.distance = @(999);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageDistance] isEqualToString:@"1.00 km"]);
    
    stats.distance = @(1234);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageDistance] isEqualToString:@"1.23 km"]);
    
    stats.distance = @(1235);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageDistance] isEqualToString:@"1.24 km"]);
    
    stats.distance = @(1299);
    stats.jogs = @(10);
    XCTAssert([[stats formattedAverageDistance] isEqualToString:@"0.13 km"]);
}

- (void)testFormattedAverageSpeed
{
    WeeklyStats *stats = [WeeklyStats new];
    XCTAssert([stats formattedAverageSpeed] == nil);
    
    stats.distance = @(0);
    XCTAssert([stats formattedAverageSpeed] == nil);
    
    stats.time = @(0);
    XCTAssert([stats formattedAverageSpeed] == nil);
    
    stats.distance = @(1);
    stats.time = @(1);
    stats.jogs = @(0);
    XCTAssert([stats formattedAverageSpeed] == nil);
    
    stats.distance = @(1000);
    stats.time = @(60*60);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageSpeed] isEqualToString:@"1.00 km/h"]);
    
    stats.distance = @(999);
    stats.time = @(60*60);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageSpeed] isEqualToString:@"1.00 km/h"]);
    
    stats.distance = @(1900);
    stats.time = @(2*60*60);
    stats.jogs = @(1);
    XCTAssert([[stats formattedAverageSpeed] isEqualToString:@"0.95 km/h"]);
    
    stats.distance = @(999);
    stats.time = @(60*60);
    stats.jogs = @(2);
    XCTAssert([[stats formattedAverageSpeed] isEqualToString:@"0.50 km/h"]);
    
    stats.distance = @(10000);
    stats.time = @(2*60*60);
    stats.jogs = @(2);
    XCTAssert([[stats formattedAverageSpeed] isEqualToString:@"2.50 km/h"]);
}

- (void)testUpdateWithDictionary
{
    WeeklyStats *stats = [WeeklyStats new];
    [stats updateWithDictionary:nil];
    XCTAssert(!stats.startDate);
    XCTAssert(!stats.endDate);
    XCTAssert(!stats.time);
    XCTAssert(!stats.distance);
    XCTAssert(!stats.jogs);
    
    [stats updateWithDictionary:@{}];
    XCTAssert(!stats.startDate);
    XCTAssert(!stats.endDate);
    XCTAssert(!stats.time);
    XCTAssert(!stats.distance);
    XCTAssert(!stats.jogs);
    
    NSDictionary *dictionary = @{
        @"startDate": @"BAD",
        @"endDate": @(0),
        @"time": [NSNull null],
        @"distance": @"",
        @"jogs": [NSDate date]
    };
    [stats updateWithDictionary:dictionary];
    XCTAssert(!stats.startDate);
    XCTAssert(!stats.endDate);
    XCTAssert(!stats.time);
    XCTAssert(!stats.distance);
    XCTAssert(!stats.jogs);
    
    dictionary = @{
        @"startDate": @{@"__type": @"Date", @"iso": @"2014-12-08T00:00:00.000Z"},
        @"endDate": @{@"__type": @"Date", @"iso": @"2014-12-14T23:59:59.999Z"},
        @"time": @(1000),
        @"distance": @(500),
        @"jogs": @(7)
    };
    [stats updateWithDictionary:dictionary];
    NSDate *expectedStartDate = [NSDate dateWithParseDictionary:dictionary[@"startDate"]];
    NSDate *expectedEndDate = [NSDate dateWithParseDictionary:dictionary[@"endDate"]];
    XCTAssert([stats.startDate isEqualToDate:expectedStartDate]);
    XCTAssert([stats.endDate isEqualToDate:expectedEndDate]);
    XCTAssert([stats.time isEqual:@(1000)]);
    XCTAssert([stats.distance isEqual:@(500)]);
    XCTAssert([stats.jogs isEqual:@(7)]);
}

@end

//
//  JogCellTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "JogCell.h"


@interface JogCellTests : XCTestCase

@end


@implementation JogCellTests

- (void)testUpdateWithJog
{
    JogCell *cell = [[JogCell alloc] init];
    UILabel *timeAndDistanceLabel = [[UILabel alloc] init];
    cell.timeAndDistanceLabel = timeAndDistanceLabel;
    UILabel *dateLabel = [[UILabel alloc] init];
    cell.dateLabel = dateLabel;
    [cell updateWithJog:nil];
    XCTAssert([cell.timeAndDistanceLabel.text isEqual:@"No jogs yet, go for a run!"]);
    XCTAssert([cell.dateLabel.text isEqual:@""]);
    Jog *jog = [[Jog alloc] init];
    jog.distance = @(12345);
    jog.time = @(1*60*60 + 23*60 + 45);
    jog.date = [NSDate date];
    [cell updateWithJog:jog];
    XCTAssert([cell.timeAndDistanceLabel.text isEqual:[jog description]]);
    XCTAssert([cell.dateLabel.text isEqual:[jog formattedDate]]);
    
}

@end

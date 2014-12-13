//
//  WeeklyStats.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/13/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryRepresentation.h"


/**
 * Represents the jog stats for a given week.
 */
@interface WeeklyStats : NSObject <DictionaryRepresentation>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSNumber *time;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSNumber *jogs;

#pragma mark - Formatted data

/**
 * Returns the formatted start and end dates of the receiver.
 */
- (NSString*)formattedDates;

/**
 * Returns the formatted average time of the receiver.
 */
- (NSString*)formattedAverageTime;

/**
 * Returns the formatted average distance of the receiver.
 */
- (NSString*)formattedAverageDistance;

/**
 * Returns the formatted average speed of the receiver.
 */
- (NSString*)formattedAverageSpeed;

@end

//
//  WeeklyStats.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/13/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "WeeklyStats.h"
#import "NSDate+Parse.h"


@implementation WeeklyStats

#pragma mark - DictionaryRepresentation

- (void)updateWithDictionary:(NSDictionary*)dictionary
{
    NSDictionary *startDate = dictionary[@"startDate"];
    if(startDate && [startDate isKindOfClass:[NSDictionary class]]){
        self.startDate = [NSDate dateWithParseDictionary:startDate];
    }
    NSDictionary *endDate = dictionary[@"endDate"];
    if(endDate && [endDate isKindOfClass:[NSDictionary class]]){
        self.endDate = [NSDate dateWithParseDictionary:endDate];
    }
    NSNumber *time = dictionary[@"time"];
    if(time && [time isKindOfClass:[NSNumber class]]){
        self.time = time;
    }
    NSNumber *distance = dictionary[@"distance"];
    if(distance && [distance isKindOfClass:[NSNumber class]]){
        self.distance = distance;
    }
    NSNumber *jogs = dictionary[@"jogs"];
    if(jogs && [jogs isKindOfClass:[NSNumber class]]){
        self.jogs = jogs;
    }
}


#pragma mark - Formatted data

- (NSString*)formattedDates
{
    NSString *formattedStartDate = [[WeeklyStats sharedDateFormatter] stringFromDate:self.startDate];
    NSString *formattedEndDate = [[WeeklyStats sharedDateFormatter] stringFromDate:self.endDate];
    return [NSString stringWithFormat:NSLocalizedString(@"StatsHeaderFormatString", nil), formattedStartDate, formattedEndDate];
}

- (NSString*)formattedAverageTime
{
    NSInteger jogs = [self jogsValue];
    NSInteger time = [self.time integerValue];
    NSInteger averageTime = jogs > 0 ? time / jogs / 60 : 0;
    return [NSString stringWithFormat:NSLocalizedString(@"StatsAverageTimeFormatString", nil), averageTime];
}

- (NSString*)formattedAverageDistance
{
    float jogs = (float)[self jogsValue];
    float distance = [self.distance floatValue];
    float averageDistance = jogs > 0.0f ? (float)distance / jogs / 1000.0f : 0;
    return [NSString stringWithFormat:NSLocalizedString(@"StatsDistanceFormatString", nil), averageDistance];
}

- (NSString*)formattedAverageSpeed
{
    float averageSpeed = ([self.distance floatValue] / 1000.0f) / ([self.time floatValue] / 60.0f / 60.0f);
    return [NSString stringWithFormat:NSLocalizedString(@"StatsSpeedFormatString", nil), averageSpeed];
}

#pragma mark - Helpers

+ (NSDateFormatter*)sharedDateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSDateFormatter alloc] init];
        sharedInstance.dateStyle = NSDateFormatterShortStyle;
        sharedInstance.timeStyle = NSDateFormatterNoStyle;
    });
    return sharedInstance;
}

- (NSInteger)jogsValue
{
    return [self.jogs integerValue];
}

@end

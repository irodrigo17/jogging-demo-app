//
//  Jog.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "Jog.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>


@implementation Jog

#pragma mark - Dictionary representation

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    if(dictionary[@"distance"]){
        self.distance = dictionary[@"distance"];
    }
    if(dictionary[@"time"]){
        self.time = dictionary[@"time"];
    }
    if(dictionary[@"date"]){
        NSString *date = dictionary[@"date"];
        // TODO: use a shared date formatter
        self.date = [[[ISO8601DateFormatter alloc] init] dateFromString:date];
    }
    if(dictionary[@"objectId"]){
        self.objectId = dictionary[@"objectId"];
    }
}

- (NSMutableDictionary*)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(self.distance){
        dictionary[@"distance"] = self.distance;
    }
    if(self.time){
        dictionary[@"time"] = self.time;
    }
    if(self.date){
        dictionary[@"date"] = self.date;
    }
    if(self.objectId){
        dictionary[@"objectId"] = self.objectId;
    }
    return dictionary;
}


#pragma mark - Formatted data

- (float)distanceInKm
{
    return self.distance ? [self.distance floatValue] / 1000.0f : 0.0f;
}


- (NSString*)formattedTime
{
    NSInteger timeInSeconds = [self.time integerValue];
    NSInteger s =  timeInSeconds % 60;
    NSInteger m = (timeInSeconds / 60) % 60;
    NSInteger h = (timeInSeconds / 60 / 60);
    NSString *hours = h ? [NSString stringWithFormat:@"%li:", h] : @"";
    return [NSString stringWithFormat:@"%@%02li:%02li", hours, m, s];
}


- (NSString*)formattedTimeAndDistance
{
    return [NSString stringWithFormat:@"%.2f km in %@", [self distanceInKm], [self formattedTime]];
}


- (NSString*)formattedDate
{
    // TODO: use a shared date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    return self.date ? [dateFormatter stringFromDate:self.date] : @"";
}


@end

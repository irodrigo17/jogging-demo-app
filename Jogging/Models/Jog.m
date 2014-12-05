//
//  Jog.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "Jog.h"
#import "DateHelper.h"
#import "User.h"


@implementation Jog

#pragma mark - Dictionary representation

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    NSNumber *distance = dictionary[@"distance"];
    if(distance && [distance isKindOfClass:[NSNumber class]]){
        self.distance = distance;
    }
    NSNumber *time = dictionary[@"time"];
    if(time && [time isKindOfClass:[NSNumber class]]){
        self.time = time;
    }
    NSDictionary *dateDic = dictionary[@"date"];
    if(dateDic && [dateDic isKindOfClass:[NSDictionary class]]){
        NSDate *date = [DateHelper deserializeParseDate:dateDic];
        if(date){
            self.date = date;
        }
    }
    NSString *objectId = dictionary[@"objectId"];
    if(objectId && [objectId isKindOfClass:[NSString class]]){
        self.objectId = objectId;
    }
    NSString *userId = dictionary[@"user"][@"objectId"];
    if(userId && [userId isKindOfClass:[NSString class]]){
        self.userId = userId;
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
        NSDictionary *dateDic = [DateHelper serializeParseDate:self.date];
        if(dateDic){
            dictionary[@"date"] = dateDic;
        }
    }
    if(self.objectId){
        dictionary[@"objectId"] = self.objectId;
    }
    if(self.userId){
        dictionary[@"user"] = @{
            @"__type": @"Pointer",
            @"className": @"_User",
            @"objectId": self.userId
        };
    }
    return dictionary;
}


#pragma mark - Formatted data

- (float)distanceInKm
{
    return self.distance ? [self.distance floatValue] / 1000.0f : 0.0f;
}


- (float)averageSpeed
{
    return [self.time floatValue] > 0 ? [self distanceInKm] / ([self.time floatValue] / 60.0f / 60.0f) : 0.0f;
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


- (NSString*)formattedDate
{
    // TODO: use a shared date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    return self.date ? [dateFormatter stringFromDate:self.date] : @"";
}

- (NSString*)formattedAverageSpeed
{
    return [NSString stringWithFormat:@"%.2f km/h", [self averageSpeed]];
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"%.2f km in %@, %@ avg", [self distanceInKm], [self formattedTime], [self formattedAverageSpeed]];
}


@end

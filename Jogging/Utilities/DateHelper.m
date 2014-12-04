//
//  DateHelper.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "DateHelper.h"
#import <ISO8601/ISO8601.h>


@implementation DateHelper

+ (NSDate*)deserializeParseDate:(NSDictionary*)dictionary
{
    NSString *ISO8601String = dictionary[@"iso"];
    return ISO8601String ? [NSDate dateWithISO8601String:ISO8601String] : nil;
}


+ (NSDictionary*)serializeParseDate:(NSDate*)date
{
    NSString *ISO8601String = [date ISO8601String];
    return ISO8601String ? @{@"__type": @"Date", @"iso": ISO8601String} : nil;
}

@end

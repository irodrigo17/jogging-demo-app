//
//  DateHelper.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <ISO8601/ISO8601.h>
#import "NSDate+Parse.h"


@implementation NSDate (Parse)

+ (NSDate*)dateWithParseDictionary:(NSDictionary*)dictionary
{
    NSString *ISO8601String = dictionary[@"iso"];
    return ISO8601String ? [NSDate dateWithISO8601String:ISO8601String] : nil;
}


- (NSDictionary*)parseDictionary
{
    NSString *ISO8601String = [self ISO8601String];
    return ISO8601String ? @{@"__type": @"Date", @"iso": ISO8601String} : nil;
}

@end

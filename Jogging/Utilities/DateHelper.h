//
//  DateHelper.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

// TODO: Use an NSDate category instead

/**
 * Desearileze the given date.
 * @param date A Parse.com date dictionary, the value for the 'iso' key is deserialized as an ISO8601 formatted string as described in https://www.parse.com/docs/rest#objects-types
 * @return The deserialized date.
 */
+ (NSDate*)deserializeParseDate:(NSDictionary*)dictionary;

/**
 * Serialize the given date.
 * @param date The date to serialize.
 * @return The serialized date dictionary for Parse.com, as described in https://www.parse.com/docs/rest#objects-types
 */
+ (NSDictionary*)serializeParseDate:(NSDate*)date;

@end

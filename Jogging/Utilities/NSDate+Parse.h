//
//  DateHelper.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Parse)

/**
 * Create a date with the given Parse dictionary representation.
 * @param date A Parse.com date dictionary, the value for the 'iso' key is deserialized as an ISO8601 formatted string as described in https://www.parse.com/docs/rest#objects-types
 * @return The deserialized date.
 */
+ (NSDate*)dateWithParseDictionary:(NSDictionary*)dictionary;

/**
 * Serialize the receiver to a Parse dictionary representation.
 * @return The serialized date dictionary for Parse.com, as described in https://www.parse.com/docs/rest#objects-types
 */
- (NSDictionary*)parseDictionary;

@end

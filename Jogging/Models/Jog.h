//
//  Jog.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryRepresentation.h"

@interface Jog : NSObject <DictionaryRepresentation>

@property (strong) NSNumber *distance;
@property (strong) NSNumber *time;
@property (strong) NSDate *date;
@property (strong) NSString *objectId;


/**
 * Returns the distance of the receiver in kilometers.
 */
- (float)distanceInKm;

/**
 * Calculates the average speed in km/h.
 */
- (float)averageSpeed;

/**
 * Returns the time of the receiver formatted like hh:mm:ss.
 */
- (NSString*)formattedTime;

/**
 * Returns the date of the receiver formatted for presentation.
 */
- (NSString*)formattedDate;

/**
 * Returns the average speed in km/h of the receiver formatted for presentation.
 */
- (NSString*)formattedAverageSpeed;



@end

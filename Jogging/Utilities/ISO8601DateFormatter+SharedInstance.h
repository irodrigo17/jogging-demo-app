//
//  ISO8601DateFormatter+SharedInstance.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/3/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "ISO8601DateFormatter.h"

@interface ISO8601DateFormatter (SharedInstance)

/**
 * Returns the shared `ISO8601DateFormatter` instance.
 */
+ (instancetype)sharedInstance;

@end

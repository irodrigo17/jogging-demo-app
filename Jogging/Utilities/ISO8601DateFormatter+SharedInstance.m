//
//  ISO8601DateFormatter+SharedInstance.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/3/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "ISO8601DateFormatter+SharedInstance.h"

@implementation ISO8601DateFormatter (SharedInstance)

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ISO8601DateFormatter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.includeTime = YES;
        sharedInstance.timeSeparator = 'T';
        sharedInstance.timeZoneSeparator = 'Z';
    });
    return sharedInstance;
}

@end

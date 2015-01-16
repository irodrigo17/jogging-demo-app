//
//  Logging.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 1/16/15.
//  Copyright (c) 2015 Ignacio Rodrigo. All rights reserved.
//

#import "Logging.h"

@implementation Logging

+ (void)load
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end

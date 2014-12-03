//
//  JogManager.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Jog.h"


/**
 * The `JogManager` class handles all jog API related actions like CRUD operations.
 */
@interface JogManager : NSObject

/**
 * Get the shared JogManager instance.
 * @return The shared JogManager instance.
 */
+ (instancetype)sharedInstance;


/**
 * Gets all jogs for the given user, and executes the proper code block upon completion.
 * @param user The user to get the jogs for.
 * @param success The code block to be executed if the jogs are retrieved successfully, it receives an array of Jog instances as a parameter.
 * @param fail The code block to be executed if there's any error retrieving the jogs, it receives an NSError instance as a parameter.
 */
- (void)getAllJogsForUser:(User *)user success:(void (^)(NSArray *jogs))success fail:(void (^)(NSError *error))fail;

@end

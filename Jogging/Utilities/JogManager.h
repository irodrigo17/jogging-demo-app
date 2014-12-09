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
 * Gets jogs for the given user, and executes the proper code block upon completion.
 * @param user The user to get the jogs for.
 * @param limit The maximum number of jogs to get per request.
 * @param skip The skip value used for pagination.
 * @param filters The filters to apply, currently it supports `from` and `to` dates.
 * @param success The code block to be executed if the jogs are retrieved successfully, it receives an array of Jog instances as a parameter.
 * @param fail The code block to be executed if there's any error retrieving the jogs, it receives an NSError instance as a parameter.
 */
- (void)getJogsForUser:(User *)user limit:(NSInteger)limit skip:(NSInteger)skip filters:(NSDictionary*)filters success:(void (^)(NSMutableArray *jogs))success fail:(void (^)(NSError *error))fail;

/**
 * Saves the given jog and executes the proper code block upon completion.
 * @param jog The jog to save.
 * @param success The code block to be executed if the jog is saved successfully, it receives the updated jog as a parameter.
 * @param fail The code block to be executed if there's any error saving the jog, it receives an NSError instance as a parameter.
 */
- (void)postJog:(Jog *)jog success:(void (^)(Jog *jog))success fail:(void (^)(NSError *error))fail;


/**
 * Delete the given jog and executes the proper code block upon completion.
 * @param jog The jog to delete.
 * @param success The code block to be executed if the jog is deleted successfully, it receives the updated jog as a parameter.
 * @param fail The code block to be executed if there's any error deleting the jog, it receives an NSError instance as a parameter.
 */
- (void)deleteJog:(Jog *)jog success:(void (^)(Jog *jog))success fail:(void (^)(NSError *error))fail;

/**
 * Update the given jog and executes the proper code block upon completion.
 * @param jog The jog to update.
 * @param success The code block to be executed if the jog is updated successfully, it receives the updated jog as a parameter.
 * @param fail The code block to be executed if there's any error updating the jog, it receives an NSError instance as a parameter.
 */
- (void)updateJog:(Jog *)jog success:(void (^)(Jog *jog))success fail:(void (^)(NSError *error))fail;



@end

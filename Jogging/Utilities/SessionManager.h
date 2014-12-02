//
//  SessionManager.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

/**
 * The SessionManager class handles all session related actions like sign up and login, and stores current session information.
 */
@interface SessionManager : NSObject

/**
 * The user that is currently signed in.
 * This property is readonly, it will be set automatically when the user signs in successfully, and cleared when the user signs out.
 */
@property (readonly, strong) User *user;

/**
 * Get the shared SessionManager instance.
 * @return The shared SessionManager instance.
 */
+ (instancetype)sharedInstance;

/**
 * Attemps to sign up with the given user asynchronously, and executes the proper block upon completion.
 * @param user The user that is signing up, it should have email and password properties set.
 * @param success The block to be executed if the sign up is successfull, receives the complete user information as a parameter.
 * @param fail The block to be ececuted if the sign up fails for any reason, it receives an NSError instance as a parameter with the failure information.
 */
- (void)signUpWithUser:(User*)user success:(void (^)(User *user))success fail:(void (^)(NSError *error))fail;

/**
 * Attemps to sign in with the given user asynchronously, and executes the proper block upon completion.
 * @param user The user that is signing in, it should have email and password properties set.
 * @param success The block to be executed if the sign in is successfull, receives the complete user information as a parameter.
 * @param fail The block to be ececuted if the sign in fails for any reason, it receives an NSError instance as a parameter with the failure information.
 */
- (void)signInWithUser:(User*)user success:(void (^)(User *user))success fail:(void (^)(NSError *error))fail;


/**
 * Clear all session information for the current user.
 */
- (void)signOut;

@end

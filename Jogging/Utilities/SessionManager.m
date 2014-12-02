//
//  SessionManager.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "SessionManager.h"
#import "APIManager.h"


@interface SessionManager ()

/**
 * Sets the current user and updates the shared `APIManager` with the user's session token.
 */
- (void)setCurrentUser:(User*)user;

@end


@implementation SessionManager

#pragma mark - Public interface

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SessionManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void)signUpWithUser:(User*)user success:(void (^)(User *user))success fail:(void (^)(NSError *error))fail
{
    [[APIManager sharedInstance] POST:@"users" parameters:[user dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [user updateWithDictionary:responseObject];
        [self setCurrentUser:user];
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
    
}


- (void)signInWithUser:(User*)user success:(void (^)(User *user))success fail:(void (^)(NSError *error))fail
{
    [[APIManager sharedInstance] GET:@"login" parameters:[user dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [user updateWithDictionary:responseObject];
        _user = user;
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}


- (void)signOut
{
    [self setCurrentUser:nil];
}

#pragma mark - Private interface

- (void)setCurrentUser:(User*)user
{
    _user = user;
    [[APIManager sharedInstance].requestSerializer setValue:user.sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
}

@end

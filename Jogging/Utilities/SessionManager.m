//
//  SessionManager.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "SessionManager.h"
#import "APIManager.h"


static NSString * const kUserKey = @"kUserKey";


@interface SessionManager ()

@end


@implementation SessionManager

#pragma mark - Public interface

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SessionManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // TODO: optimize this, user is unnecessarily stored again
        [sharedInstance setCurrentUser:[sharedInstance loadUser]];
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
        [self setCurrentUser:user];
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}


- (void)signOut
{
    [self setCurrentUser:nil];
}

- (void)setCurrentUser:(User*)user
{
    _user = user;
    [self storeUser:user];
    [[APIManager sharedInstance].requestSerializer setValue:user.sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
}

- (void)storeUser:(User *)user
{
    if(user){
        user.password = nil;
        [[NSUserDefaults standardUserDefaults] setObject:[user dictionary] forKey:kUserKey];
    }
    else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
    }
}

- (User*)loadUser
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserKey];
    User *user = nil;
    if(dic){
        user = [[User alloc] init];
        [user updateWithDictionary:dic];
    }
    return user;
}

@end

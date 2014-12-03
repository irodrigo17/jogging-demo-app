//
//  User.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark - Dictionary representation

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    NSString *name = dictionary[@"name"];
    if(name && [name isKindOfClass:[NSString class]]){
        self.name = name;
    }
    NSString *username = dictionary[@"username"];
    if(username && [username isKindOfClass:[NSString class]]){
        self.username = username;
    }
    NSString *email = dictionary[@"email"];
    if(email && [email isKindOfClass:[NSString class]]){
        self.email = email;
    }
    NSString *password = dictionary[@"password"];
    if(password && [password isKindOfClass:[NSString class]]){
        self.password = password;
    }
    NSString *sessionToken = dictionary[@"sessionToken"];
    if(sessionToken && [sessionToken isKindOfClass:[NSString class]]){
        self.sessionToken = sessionToken;
    }
    NSString *objectId = dictionary[@"objectId"];
    if(objectId && [objectId isKindOfClass:[NSString class]]){
        self.objectId = objectId;
    }
}

- (NSMutableDictionary*)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(self.name){
        dictionary[@"name"] = self.name;
    }
    if(self.username){
        dictionary[@"username"] = self.username;
    }
    if(self.email){
        dictionary[@"email"] = self.email;
    }
    if(self.password){
        dictionary[@"password"] = self.password;
    }
    if(self.sessionToken){
        dictionary[@"sessionToken"] = self.sessionToken;
    }
    if(self.objectId){
        dictionary[@"objectId"] = self.objectId;
    }
    return dictionary;
}

@end

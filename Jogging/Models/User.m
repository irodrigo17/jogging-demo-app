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
    if(dictionary[@"name"]){
        self.name = dictionary[@"name"];
    }
    if(dictionary[@"username"]){
        self.username = dictionary[@"username"];
    }
    if(dictionary[@"email"]){
        self.email = dictionary[@"email"];
    }
    if(dictionary[@"password"]){
        self.password = dictionary[@"password"];
    }
    if(dictionary[@"sessionToken"]){
        self.sessionToken = dictionary[@"sessionToken"];
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
    return dictionary;
}

@end

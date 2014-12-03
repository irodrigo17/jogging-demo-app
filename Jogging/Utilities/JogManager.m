//
//  JogManager.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "JogManager.h"
#import "APIManager.h"


@implementation JogManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static JogManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getAllJogsForUser:(User *)user success:(void (^)(NSArray *jogs))success fail:(void (^)(NSError *error))fail
{
    [[APIManager sharedInstance] GET:@"jogs" parameters:@{@"user": user} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *jogs = [NSMutableArray array];
        for(NSDictionary *dic in responseObject){
            Jog *jog = [[Jog alloc] init];
            [jog updateWithDictionary:dic];
            [jogs addObject:jog];
        }
        success(jogs);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

@end

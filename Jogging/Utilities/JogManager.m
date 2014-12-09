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

- (void)getJogsForUser:(User *)user limit:(NSInteger)limit skip:(NSInteger)skip success:(void (^)(NSMutableArray *jogs))success fail:(void (^)(NSError *error))fail;
{
    
    NSString *query = [NSString stringWithFormat:@"{\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"%@\"}}", user.objectId];
    NSDictionary *parameters = @{@"where": query, @"limit": @(limit), @"skip": @(skip)};
    [[APIManager sharedInstance] GET:@"classes/Jog" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *jogs = [NSMutableArray array];
        for(NSDictionary *dic in responseObject[@"results"]){
            Jog *jog = [[Jog alloc] init];
            [jog updateWithDictionary:dic];
            [jogs addObject:jog];
        }
        success(jogs);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)postJog:(Jog *)jog success:(void (^)(Jog *jog))success fail:(void (^)(NSError *error))fail
{
    [[APIManager sharedInstance] POST:@"classes/Jog" parameters:[jog dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [jog updateWithDictionary:responseObject];
        success(jog);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)deleteJog:(Jog *)jog success:(void (^)(Jog *jog))success fail:(void (^)(NSError *error))fail
{
    NSString *path = [NSString stringWithFormat:@"classes/Jog/%@", jog.objectId];
    [[APIManager sharedInstance] DELETE:path parameters:[jog dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [jog updateWithDictionary:responseObject];
        success(jog);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)updateJog:(Jog *)jog success:(void (^)(Jog *jog))success fail:(void (^)(NSError *error))fail
{
    NSString *path = [NSString stringWithFormat:@"classes/Jog/%@", jog.objectId];
    [[APIManager sharedInstance] PUT:path parameters:[jog dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [jog updateWithDictionary:responseObject];
        success(jog);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

@end

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
    // TODO: add pagination
    NSString *query = [NSString stringWithFormat:@"{\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"%@\"}}", user.objectId];
    NSDictionary *parameters = @{@"where": query};
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

@end

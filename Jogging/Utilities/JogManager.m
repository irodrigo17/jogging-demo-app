//
//  JogManager.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "JogManager.h"
#import "APIManager.h"
#import <ISO8601/ISO8601.h>
#import "NSDate+Parse.h"


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

- (void)getJogsForUser:(User *)user limit:(NSInteger)limit skip:(NSInteger)skip filters:(NSDictionary *)filters success:(void (^)(NSMutableArray *))success fail:(void (^)(NSError *))fail
{
    // create query JSON
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[@"user"] = [user parsePointerDictionary];
    NSMutableDictionary *date = [NSMutableDictionary dictionary];
    NSDate *from = filters[@"from"];
    if(from){
        date[@"$gte"] = [from parseDictionary];
    }
    NSDate *to = filters[@"to"];
    if(to){
        date[@"$lte"] = [to parseDictionary];
    }
    if([date count]){
        query[@"date"] = date;
    }
    NSError *err = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:query options:0 error:&err];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    
    // perform request
    NSDictionary *parameters = @{@"where": JSONString, @"limit": @(limit), @"skip": @(skip)};
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
    NSMutableDictionary *params = [jog dictionary];
    [[APIManager sharedInstance] POST:@"classes/Jog" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

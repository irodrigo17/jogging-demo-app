//
//  APIManager.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "APIManager.h"
#import <FormatterKit/TTTURLRequestFormatter.h>


@implementation APIManager

#pragma mark - Initialization

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static APIManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        // TODO: use multiple environments
        NSURL *baseURL = [NSURL URLWithString:@"https://api.parse.com/1/"];
        sharedInstance = [[self alloc] initWithBaseURL:baseURL];
        
        // setup request serializer
        sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedInstance.requestSerializer setValue:@"miw8ufMpwGjfvnuLssMXMNs0xNqThjWDRKJC2ELl" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [sharedInstance.requestSerializer setValue:@"fCtvn92JEjCElNM1kfGIicIB3AvP5lO7pLUIznLv" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [sharedInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [sharedInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // setup response serializer
        sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sharedInstance;
}

#pragma mark - AFHTTPRequestOperationManager overrides

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
    // log request
    NSLog(@"request: %@", [TTTURLRequestFormatter cURLCommandFromURLRequest:request]);
    return operation;
}

@end

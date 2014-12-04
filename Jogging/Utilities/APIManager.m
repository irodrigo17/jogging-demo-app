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
    // log request
    NSLog(@"request: %@", [TTTURLRequestFormatter cURLCommandFromURLRequest:request]);
    
    // add response logging
    void (^logResponse)(AFHTTPRequestOperation *) = ^void(AFHTTPRequestOperation *operation){
        NSString *response = [[TTTHTTPURLResponseFormatter new] stringFromHTTPURLResponse:operation.response];
        NSLog(@"response: %@\nheaders: %@\nbody: %@", response, operation.response.allHeaderFields, operation.responseString);
    };
    
    void (^successWithLogging)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id responseObject) {
        logResponse(operation);
        if(success){
            success(operation, responseObject);
        }
    };
    
    void (^failWithLogging)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        logResponse(operation);
        if(failure){
            failure(operation, error);
        }
    };
    
    return [super HTTPRequestOperationWithRequest:request success:successWithLogging failure:failWithLogging];
}

@end

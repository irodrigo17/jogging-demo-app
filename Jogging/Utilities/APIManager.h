//
//  APIManager.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

/**
 * `APIManager` extends `AFHTTPRequestOperationManager` to encapsulate API communication.
 */
@interface APIManager : AFHTTPRequestOperationManager

/**
 * Returns the shared `APIManager` instance.
 * This instance is already setup to make requests to our RESTful API.
 */
+ (instancetype)sharedInstance;

@end

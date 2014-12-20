//
//  NSError+AFNetworking.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/10/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (AFNetworking)

- (BOOL)isNetworkError;

- (NSInteger)HTTPStatus;

@end

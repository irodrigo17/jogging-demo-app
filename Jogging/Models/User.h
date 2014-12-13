//
//  User.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryRepresentation.h"


@interface User : NSObject <DictionaryRepresentation>

@property (strong) NSString *name;
@property (strong) NSString *username;
@property (strong) NSString *email;
@property (strong) NSString *password;
@property (strong) NSString *sessionToken;
@property (strong) NSString *objectId;


/**
 * Creates a Parse.com dictionary representation of the receiver to use in relationships queries.
 */
- (NSDictionary*)parsePointerDictionary;

/**
 * Creates a Parse.com dictionary representation with the given user ID to use in relationships queries.
 */
+ (NSDictionary*)parsePointerDictionaryWithUserId:(NSString*)userId;

@end

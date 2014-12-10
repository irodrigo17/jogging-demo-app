//
//  NSDictionary+XLForm.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/10/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XLForm)

/**
 * Creates a new dictionary by copying the receiver without the NSNull instances.
 */
- (NSDictionary*)dictionaryWithoutNulls;

@end

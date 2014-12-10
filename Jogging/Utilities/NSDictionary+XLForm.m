//
//  NSDictionary+XLForm.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/10/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "NSDictionary+XLForm.h"

@implementation NSDictionary (XLForm)

- (NSDictionary*)dictionaryWithoutNulls
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(NSString *key in [self allKeys]){
        id value = self[key];
        if(value != [NSNull null]){
            dic[key] = value;
        }
    }
    return dic;
}

@end

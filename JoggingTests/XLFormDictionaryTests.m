//
//  XLFormDictionaryTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/13/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDictionary+XLForm.h"


@interface XLFormDictionaryTests : XCTestCase

@end

@implementation XLFormDictionaryTests

- (void)testDictionaryWithoutNulls
{
    NSDictionary *dictionary = nil;
    XCTAssert([dictionary dictionaryWithoutNulls] == nil);
    
    dictionary = @{};
    XCTAssert([[dictionary dictionaryWithoutNulls] isEqualToDictionary:dictionary]);
    
    dictionary = @{@"key": @"value"};
    XCTAssert([[dictionary dictionaryWithoutNulls] isEqualToDictionary:dictionary]);
    
    dictionary = @{@"key": [NSNull null]};
    XCTAssert([[dictionary dictionaryWithoutNulls] isEqualToDictionary:@{}]);
    
    dictionary = @{@"key": @"value", @"null": [NSNull null]};
    XCTAssert([[dictionary dictionaryWithoutNulls] isEqualToDictionary:@{@"key": @"value"}]);
}

@end

//
//  UserTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "User.h"


@interface UserTests : XCTestCase

@end

@implementation UserTests

- (void)testUpdateWithDictionary
{
    User *user = [[User alloc] init];
    [user updateWithDictionary:@{}];
    XCTAssert(!user.name);
    XCTAssert(!user.username);
    XCTAssert(!user.email);
    XCTAssert(!user.password);
    XCTAssert(!user.sessionToken);
    XCTAssert(!user.objectId);
    
    [user updateWithDictionary:@{}];
    XCTAssert(!user.name);
    XCTAssert(!user.username);
    XCTAssert(!user.email);
    XCTAssert(!user.password);
    XCTAssert(!user.sessionToken);
    XCTAssert(!user.objectId);
    
    NSDictionary *dic = @{@"name": @"My Name", @"username": @"my-username", @"email": @"me@domain.com", @"password": @"my_pass", @"sessionToken": @"my_token!", @"objectId": @"my-object-id"};
    [user updateWithDictionary:dic];
    XCTAssert([user.name isEqual:dic[@"name"]]);
    XCTAssert([user.username isEqual:dic[@"username"]]);
    XCTAssert([user.email isEqual:dic[@"email"]]);
    XCTAssert([user.password isEqual:dic[@"password"]]);
    XCTAssert([user.sessionToken isEqual:dic[@"sessionToken"]]);
    XCTAssert([user.objectId isEqual:dic[@"objectId"]]);
    
    NSDictionary *badDic = @{@"name": @(1), @"username": @(2), @"email": @(3), @"password": @(4), @"sessionToken": @(5), @"objectId": @(6)};
    [user updateWithDictionary:badDic];
    XCTAssert([user.name isEqual:dic[@"name"]]);
    XCTAssert([user.username isEqual:dic[@"username"]]);
    XCTAssert([user.email isEqual:dic[@"email"]]);
    XCTAssert([user.password isEqual:dic[@"password"]]);
    XCTAssert([user.sessionToken isEqual:dic[@"sessionToken"]]);
    XCTAssert([user.objectId isEqual:dic[@"objectId"]]);
}

- (void)testDictionary
{
    User *user = [[User alloc] init];
    XCTAssert([[user dictionary] isEqual:@{}]);
    user.name = @"My Name";
    user.username = @"my_username";
    user.email = @"me@domain.com";
    user.password = @"my-pass";
    user.sessionToken = @"sessionToken!";
    user.objectId = @"my-obj-id";
    NSDictionary *expectedDic = @{@"name": user.name, @"username": user.username, @"email": user.email, @"password": user.password, @"sessionToken": user.sessionToken, @"objectId": user.objectId};
    XCTAssert([[user dictionary] isEqual:expectedDic]);
}

- (void)testParsePointerDictionary
{
    User *user = [User new];
    XCTAssert(![user parsePointerDictionary]);
    
    user.objectId = @"my-id";
    NSDictionary *dictionary = [user parsePointerDictionary];
    NSDictionary *expectedDictionary = @{
        @"__type": @"Pointer",
        @"className": @"_User",
        @"objectId": user.objectId};
    XCTAssert([dictionary isEqualToDictionary:expectedDictionary]);
    XCTAssert([dictionary isEqualToDictionary:[User parsePointerDictionaryWithUserId:user.objectId]]);
}

@end

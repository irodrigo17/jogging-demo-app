//
//  SessionManagerTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "SessionManager.h"
#import "APIManager.h"


static NSTimeInterval const kDefaultTimeout = 20.0f;
static NSString * const kDefaultTestUserPassword = @"password";


@interface SessionManagerTests : XCTestCase

@end

@implementation SessionManagerTests

- (void)tearDown
{
    [[SessionManager sharedInstance] signOut];
}

- (void)testSharedInstance
{
    XCTAssert([SessionManager sharedInstance] != nil);
    XCTAssert([SessionManager sharedInstance] == [SessionManager sharedInstance]);
}


- (void)testSignUp
{
    User *user = [[User alloc] init];
    
    XCTestExpectation *failExpectation = [self expectationWithDescription:@"No user info"];
    
    [[SessionManager sharedInstance] signUpWithUser:user success:^(User *user) {
        XCTFail(@"Expected fail");
        [failExpectation fulfill];
    } fail:^(NSError *error) {
        XCTAssert([SessionManager sharedInstance].user == nil);
        [failExpectation fulfill];
    }];
    
    
    XCTestExpectation *successExpectation = [self expectationWithDescription:@"Successful sign up"];
    
    user = [self randomTestUser];
    [[SessionManager sharedInstance] signUpWithUser:user success:^(User *user) {
        XCTAssert(user.username);
        XCTAssert(user.email);
        XCTAssert(user == [SessionManager sharedInstance].user);
        [successExpectation fulfill];
    } fail:^(NSError *error) {
        XCTFail(@"Expected success");
        [successExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultTimeout handler:^(NSError *error) {
        if(error){
            XCTFail(@"error: %@", error);
        }
    }];
}


- (void)testSignIn
{
    User *user = [[User alloc] init];
    
    XCTestExpectation *failExpectation = [self expectationWithDescription:@"No user info"];
    
    [[SessionManager sharedInstance] signInWithUser:user success:^(User *user) {
        XCTFail(@"Expected fail");
        [failExpectation fulfill];
    } fail:^(NSError *error) {
        XCTAssert([SessionManager sharedInstance].user == nil);
        [failExpectation fulfill];
    }];
    
    XCTestExpectation *successExpectation = [self expectationWithDescription:@"Successful sign in"];
    
    User *randomUser = [self randomTestUser];
    [[SessionManager sharedInstance] signUpWithUser:randomUser success:^(User *user) {
        user.password = kDefaultTestUserPassword;
        [[SessionManager sharedInstance] signInWithUser:user success:^(User *user) {
            XCTAssert(user.username);
            XCTAssert(user.email);
            XCTAssert(user.sessionToken);
            XCTAssert(user == [SessionManager sharedInstance].user);
            [successExpectation fulfill];
        } fail:^(NSError *error) {
            XCTFail(@"Expected success");
            [successExpectation fulfill];
        }];
    } fail:^(NSError *error) {
        XCTFail(@"Expected success");
        [successExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultTimeout handler:^(NSError *error) {
        if(error){
            XCTFail(@"error: %@", error);
        }
    }];
}


- (void)testSignOut
{
    User *user = [self randomTestUser];
    [[SessionManager sharedInstance] setCurrentUser:user];
    XCTAssert([SessionManager sharedInstance].user);
    [[SessionManager sharedInstance] signOut];
    XCTAssert(![SessionManager sharedInstance].user);
    XCTAssert(![[SessionManager sharedInstance] loadUser]);
}


- (void)testUserStorage
{
    [[SessionManager sharedInstance] storeUser:nil];
    XCTAssert(![[SessionManager sharedInstance] loadUser]);
    
    User *user = [self randomTestUser];
    user.sessionToken = @"session-token";
    [[SessionManager sharedInstance] storeUser:user];
    User *loadedUser = [[SessionManager sharedInstance] loadUser];
    XCTAssert(loadedUser);
    XCTAssert([[loadedUser dictionary] isEqualToDictionary:[user dictionary]]);
}


- (void)testSetCurrentUser
{
    [[SessionManager sharedInstance] setCurrentUser:nil];
    XCTAssert(![SessionManager sharedInstance].user);
    XCTAssert(![[SessionManager sharedInstance] loadUser]);
    NSDictionary *headers = [APIManager sharedInstance].requestSerializer.HTTPRequestHeaders;
    XCTAssert(!headers[@"X-Parse-Session-Token"]);
    
    User *user = [self randomTestUser];
    user.sessionToken = @"one-super-cool-token!";
    [[SessionManager sharedInstance] setCurrentUser:user];
    XCTAssert([SessionManager sharedInstance].user == user);
    XCTAssert([[SessionManager sharedInstance] loadUser]);
    headers = [APIManager sharedInstance].requestSerializer.HTTPRequestHeaders;
    XCTAssert([headers[@"X-Parse-Session-Token"] isEqualToString:user.sessionToken]);
}

- (User*)randomTestUser
{
    User *user = [User new];
    user.username = [NSString stringWithFormat:@"test-%li", (long)[[NSDate date] timeIntervalSince1970]];
    user.password = kDefaultTestUserPassword;
    user.email = [user.username stringByAppendingString:@"@email.com"];
    return user;
}

@end

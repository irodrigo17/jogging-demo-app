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


@interface SessionManagerTests : XCTestCase

@property (strong, nonatomic) User *testUser;

@end

@implementation SessionManagerTests

- (void)setUp
{
    self.testUser = [[User alloc] init];
    self.testUser.username = [NSString stringWithFormat:@"session-manager-tests-%li", (long)[[NSDate date] timeIntervalSince1970]];
    self.testUser.email = [NSString stringWithFormat:@"%@@test.com", self.testUser.username];
    self.testUser.password = @"password";
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
    
    [[SessionManager sharedInstance] signUpWithUser:self.testUser success:^(User *user) {
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
        [failExpectation fulfill];
    }];
    
    XCTestExpectation *successExpectation = [self expectationWithDescription:@"Successful sign in"];
    
    user.username = @"testuser";
    user.password = @"password";
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
    
    [self waitForExpectationsWithTimeout:kDefaultTimeout handler:^(NSError *error) {
        if(error){
            XCTFail(@"error: %@", error);
        }
    }];
}


- (void)testSignOut
{
    XCTAssert([SessionManager sharedInstance].user);
    [[SessionManager sharedInstance] signOut];
    XCTAssert(![SessionManager sharedInstance].user);
    XCTAssert(![[SessionManager sharedInstance] loadUser]);
}


- (void)testUserStorage
{
    [[SessionManager sharedInstance] storeUser:nil];
    XCTAssert(![[SessionManager sharedInstance] loadUser]);
    
    [[SessionManager sharedInstance] storeUser:self.testUser];
    User *user = [[SessionManager sharedInstance] loadUser];
    XCTAssert(user);
    XCTAssert([[user dictionary] isEqualToDictionary:[self.testUser dictionary]]);
}


- (void)testSetCurrentUser
{
    [[SessionManager sharedInstance] setCurrentUser:nil];
    XCTAssert(![SessionManager sharedInstance].user);
    XCTAssert(![[SessionManager sharedInstance] loadUser]);
    NSDictionary *headers = [APIManager sharedInstance].requestSerializer.HTTPRequestHeaders;
    XCTAssert(!headers[@"X-Parse-Session-Token"]);
    
    User *user = [User new];
    user.username = @"good-guy";
    user.email = @"good-guy@email.com";
    user.sessionToken = @"one-super-cool-token!";
    [[SessionManager sharedInstance] setCurrentUser:user];
    XCTAssert([SessionManager sharedInstance].user == user);
    XCTAssert([[SessionManager sharedInstance] loadUser]);
    headers = [APIManager sharedInstance].requestSerializer.HTTPRequestHeaders;
    XCTAssert([headers[@"X-Parse-Session-Token"] isEqualToString:user.sessionToken]);
}

@end

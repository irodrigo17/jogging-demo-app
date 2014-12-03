//
//  JogManagerTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "JogManager.h"
#import "SessionManager.h"


static NSTimeInterval const kDefaultTimeout = 20.0f;
static NSString * const kTestUserId = @"fxszRIECBm";

// TODO: call login instead to get a valid sesison token, this is fragile
static NSString * const kTestUserSessionToken = @"herOwuRBGNIeLn16GAQdKjKrd";


@interface JogManagerTests : XCTestCase

@property (strong, nonatomic) User *testUser;

@end


@implementation JogManagerTests

- (void)setUp
{
    self.testUser = [[User alloc] init];
    self.testUser.objectId = kTestUserId;
    self.testUser.sessionToken = kTestUserSessionToken;
    
    [[SessionManager sharedInstance] setCurrentUser:self.testUser];
}

- (void)tearDown
{
    [[SessionManager sharedInstance] setCurrentUser:nil];
}

- (void)testSharedInstance
{
    XCTFail(@"Implement me");
}

- (void)testGetAllJogs
{
    XCTestExpectation *failExpectation = [self expectationWithDescription:@"Missing user ID"];
    
    User *badUser = [[User alloc] init];
    [[JogManager sharedInstance] getAllJogsForUser:badUser success:^(NSArray *jogs) {
        XCTAssert([jogs count] == 0);
        [failExpectation fulfill];
    } fail:^(NSError *error) {
        XCTFail(@"User has no ID set");
        [failExpectation fulfill];
    }];
    
    XCTestExpectation *successExpectation = [self expectationWithDescription:@"Valid user ID"];
    
    [[JogManager sharedInstance] getAllJogsForUser:self.testUser success:^(NSArray *jogs) {
        XCTAssert([jogs count] == 2);
        for(Jog *jog in jogs){
            XCTAssert(jog.distance);
            XCTAssert(jog.time);
            XCTAssert(jog.date);
            XCTAssert(jog.objectId);
        }
        [successExpectation fulfill];
    } fail:^(NSError *error) {
        XCTFail(@"User has a valid ID set");
        [successExpectation fulfill];
    }];
    
    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:kDefaultTimeout handler:^(NSError *error) {
        if(error){
            XCTFail(@"error: %@", error);
        }
    }];
}

@end

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
    [[SessionManager sharedInstance] signOut];
}

- (void)testSharedInstance
{
    XCTAssert([JogManager sharedInstance] != nil);
    XCTAssert([JogManager sharedInstance] == [JogManager sharedInstance]);
}

- (void)testCRUDOperations
{
    XCTestExpectation *successExpectation = [self expectationWithDescription:@"Valid Jog"];
    
    User *user = [User new];
    user.username = [NSString stringWithFormat:@"test-CRUD-%li", (long)[[NSDate date] timeIntervalSince1970]];
    user.password = @"password";
    [[SessionManager sharedInstance] signUpWithUser:user success:^(User *user) {
        XCTAssert(user.sessionToken);
        
        
    
        // create jog
        Jog *jog = [Jog new];
        jog.time = @(12);
        jog.distance = @(12);
        jog.date = [NSDate date];
        jog.userId = user.objectId;
        
        [[JogManager sharedInstance] postJog:jog success:^(Jog *createdJog) {
            XCTAssert(createdJog.objectId);
            
            [[JogManager sharedInstance] getJogsForUser:self.testUser limit:1 skip:0 filters:nil success:^(NSMutableArray *jogs) {
                
                // find jog
                XCTAssert([jogs count] == 1);
                Jog *jog = jogs[0];
                XCTAssert(jog.objectId);
                
                // update jog
                NSNumber *distance = @(15);
                jog.distance = @(15);
                [[JogManager sharedInstance] updateJog:jog success:^(Jog *jog) {
                    XCTAssert([jog.distance isEqual:distance]);
                    
                    // delete jog
                    [[JogManager sharedInstance] deleteJog:jog success:^(Jog *jog) {
                        [successExpectation fulfill];
                    } fail:^(NSError *error) {
                        XCTFail(@"Should have deleted the jog successfuly");
                        [successExpectation fulfill];
                    }];
                    
                } fail:^(NSError *error) {
                    XCTFail(@"Should have updated the jog");
                    [successExpectation fulfill];
                }];
            } fail:^(NSError *error) {
                XCTFail(@"Should have retrieved the jogs");
                [successExpectation fulfill];
            }];

        } fail:^(NSError *error) {
            XCTFail(@"Should have created the jog");
            [successExpectation fulfill];
        }];
    } fail:^(NSError *error) {
        XCTFail(@"Should have created the jog");
        [successExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultTimeout handler:^(NSError *error) {
        if(error){
            XCTFail(@"error: %@", error);
        }
    }];
}

@end

//
//  StressTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/8/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JogManager.h"
#import "SessionManager.h"
#import "Logging.h"


static BOOL const kRunStressTests = NO;

static NSTimeInterval const kDefaultTimeout = 120.0f;
static NSInteger const kJogCount = 100;
static NSInteger const kJogTimeMin = 3000;
static NSInteger const kJogTimeMax = 5000;
static NSInteger const kJogDistanceMin = 7000;
static NSInteger const kJogDistanceMax = 12000;
static NSInteger const kJogDateMaxDaysAgo = 30;


@interface StressTests : XCTestCase

@end


@implementation StressTests

- (void)testCreateJogs{

    if(!kRunStressTests){
        return;
    }

    [self measureBlock:^{
        XCTestExpectation *expectation = [self expectationWithDescription:@"Successful sign up"];
        
        User *user = [User new];
        user.username = [NSString stringWithFormat:@"stress-%li", (long)[[NSDate date] timeIntervalSince1970]];
        user.password = @"password";
        [[SessionManager sharedInstance] signUpWithUser:user success:^(User *user) {
            XCTAssert(user.sessionToken);
            
            // create jogs
            for(int i = 0; i < kJogCount; i++){
                Jog *jog = [self randomJogWithUser:user];
                [[JogManager sharedInstance] postJog:jog success:^(Jog *jog) {
                    XCTAssert(jog.objectId);
                    if(i == kJogCount - 1){
                        [expectation fulfill];
                    }
                } fail:^(NSError *error) {
                    XCTFail(@"Failed to create jog");
                    [expectation fulfill];
                }];
            }
            
        } fail:^(NSError *error) {
            XCTFail(@"Can't sign up");
            [expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:kDefaultTimeout handler:^(NSError *error) {
            if(error){
                XCTFail(@"error: %@", error);
            }
            else{
                DDLogInfo(@"Created %li jogs for user: %@", (long)kJogCount, user.username);
            }
        }];
    }];
}

- (Jog*)randomJogWithUser:(User*)user
{
    Jog *jog = [Jog new];
    jog.time = @(arc4random_uniform(kJogTimeMax - kJogTimeMin) + kJogTimeMin);
    jog.distance = @(arc4random_uniform(kJogDistanceMax - kJogDistanceMin) + kJogDistanceMin);
    int randTimeInterval = -arc4random_uniform(kJogDateMaxDaysAgo * 24 * 60 * 60);
    jog.date = [NSDate dateWithTimeIntervalSinceNow:randTimeInterval];
    jog.userId = user.objectId;
    return jog;
}

@end

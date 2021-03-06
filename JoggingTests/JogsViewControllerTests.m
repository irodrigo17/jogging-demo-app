//
//  JogsViewControllerTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/3/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JogsViewController.h"
#import "Jog.h"
#import "JogCell.h"



@interface JogsViewControllerTests : XCTestCase

@end

@implementation JogsViewControllerTests

- (void)testUpdateUsernameWithUser
{
    JogsViewController *vc = [[JogsViewController alloc] init];
    UILabel *label = [[UILabel alloc] init];
    vc.user = label;
    
    User *user = [[User alloc] init];
    user.username = @"cool-guy";
    [vc updateUsernameWithUser:user];
    
    NSString *expectedText = [NSString stringWithFormat:@"Signed in as %@", user.username];
    XCTAssert([vc.user.text isEqualToString:expectedText]);
}

@end

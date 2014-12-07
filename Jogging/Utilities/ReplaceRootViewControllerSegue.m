//
//  ReplaceRootViewControllerSegue.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/7/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "ReplaceRootViewControllerSegue.h"
#import "AppDelegate.h"

@implementation ReplaceRootViewControllerSegue

- (void)perform
{
    UIViewController *destination = self.destinationViewController;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:destination animated:YES];
}

@end

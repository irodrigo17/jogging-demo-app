//
//  InitialViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "InitialViewController.h"
#import "SessionManager.h"


@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidAppear:(BOOL)animated
{
    if([SessionManager sharedInstance].user){
        [self performSegueWithIdentifier:@"ShowJogsNavigationViewController" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"ShowLandingViewController" sender:self];
    }
}

@end

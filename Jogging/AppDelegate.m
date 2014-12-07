//
//  AppDelegate.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "AppDelegate.h"
#import "SessionManager.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *initialViewControllerIdentifier = [SessionManager sharedInstance].user ? @"JogsNavigationController" : @"LandingViewController";
    UIViewController *initialViewController = [storyboard instantiateViewControllerWithIdentifier:initialViewControllerIdentifier];
    self.window.rootViewController = initialViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Public interface

- (void)setRootViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (!self.window.rootViewController || !animated) {
        self.window.rootViewController = viewController;
    }
    else{
        UIView *snapshot = [self.window snapshotViewAfterScreenUpdates:YES];
        [viewController.view addSubview:snapshot];
        self.window.rootViewController = viewController;
        [UIView animateWithDuration:0.5f animations:^{
            snapshot.layer.opacity = 0;
        } completion:^(BOOL finished) {
            [snapshot removeFromSuperview];
        }];
    }
}

@end

//
//  SignInViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/3/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "SignInViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "SessionManager.h"
#import "AppDelegate.h"


@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignInViewController

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signIn:(id)sender {
    // TODO: validate user information
    
    // create user from fields
    User *user = [[User alloc] init];
    user.username = self.username.text;
    user.password = self.password.text;
    
    // show progress indicator
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    // sign up using the session manager
    __weak SignInViewController *selfBlockRef = self;
    [[SessionManager sharedInstance] signInWithUser:user success:^(User *user) {
        [progressHUD dismissAnimated:YES];
        [selfBlockRef performSegueWithIdentifier:@"ShowJogsFromSignIn" sender:nil];
    } fail:^(NSError *user) {
        // TODO: check internet connection and expected API errors
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't sign in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [progressHUD dismissAnimated:YES];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO: move to the next text field or sign in
    return YES;
}

@end

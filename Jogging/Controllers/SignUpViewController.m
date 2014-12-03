//
//  SignUpViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "SignUpViewController.h"
#import "SessionManager.h"
#import <JGProgressHUD/JGProgressHUD.h>


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

/**
 * Shows the jogs view controller.
 */
- (void)showJogsViewController;

@end

@implementation SignUpViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUp:(id)sender {
    
    // TODO: validate user information
    
    // create user from fields
    User *user = [[User alloc] init];
    user.name = self.name.text;
    user.username = self.username.text;
    user.email = self.email.text;
    user.password = self.password.text;
    
    // show progress indicator
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    // sign up using the session manager
    __weak SignUpViewController *selfRef = self;
    [[SessionManager sharedInstance] signUpWithUser:user success:^(User *user) {
        [progressHUD dismissAnimated:YES];
        [selfRef showJogsViewController];
    } fail:^(NSError *user) {
        // TODO: check internet connection and expected API errors
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't sign up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [progressHUD dismissAnimated:YES];
    }];
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO: move to the next text field or sign up
    return YES;
}

#pragma mark - Private interface

- (void)showJogsViewController
{
    // TODO: change the root view controller or something to avoid keeping unnecessary view controllers in the stack.
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JogsNavigationController"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end

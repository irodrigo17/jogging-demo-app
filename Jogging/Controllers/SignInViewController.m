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
#import "NSDictionary+XLForm.h"
#import "NSError+AFNetworking.h"
#import <AFNetworking/AFURLResponseSerialization.h>
#import "Logging.h"


@interface SignInViewController ()

@end


@implementation SignInViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setupForm];
    [super viewDidLoad];
}


#pragma mark - Actions

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signIn:(id)sender
{
    // validate
    NSArray *validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    // end editing
    [self.tableView endEditing:NO];
    
    // create user from fields
    NSDictionary *formValues = [[self formValues] dictionaryWithoutNulls];
    User *user = [[User alloc] init];
    [user updateWithDictionary:formValues];
    
    // show progress indicator
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    // sign up using the session manager
    __weak SignInViewController *selfBlockRef = self;
    [[SessionManager sharedInstance] signInWithUser:user success:^(User *user) {
        [progressHUD dismissAnimated:YES];
        [selfBlockRef performSegueWithIdentifier:@"ShowJogsFromSignIn" sender:nil];
    } fail:^(NSError *error) {
        
        DDLogError(@"Can't sign in: %@", error);
        
        [progressHUD dismissAnimated:YES];
        
        NSString *title = nil;
        NSString *message = nil;
        
        // check for network error
        if([error isNetworkError]){
            title = NSLocalizedString(@"NoConnectionAlertTitle", nil);
            message = NSLocalizedString(@"NoConnectionAlertMessage", nil);
        }
        else{
            // check bad login
            NSDictionary *userInfo = [error userInfo];
            NSHTTPURLResponse *response = userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            if(response && response.statusCode == 404){
                NSData *responseData = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if(responseData){
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    int code = [responseDic[@"code"] intValue];
                    if(code == 101){
                        title = NSLocalizedString(@"BadUserDataAlertTitle", nil);
                        message = NSLocalizedString(@"AuthErrorAlertMessage", nil);
                    }
                }
            }
            
            if(!title){
                title = NSLocalizedString(@"UnexpectedErrorAlertTitle", nil);
            }
            if(!message){
                message = NSLocalizedString(@"UnexpectedErrorAlertMessage", nil);
            }
        }
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OKButtonTitle", nil) otherButtonTitles:nil] show];
    }];
}

#pragma mark - Helpers

- (void)setupForm
{
    self.form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"SignInFormTitle", nil)];
    self.form.assignFirstResponderOnShow = YES;
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [self.form addFormSection:section];
    
    XLFormRowDescriptor *usernameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"username" rowType:XLFormRowDescriptorTypeText];
    [usernameRow.cellConfigAtConfigure setObject:NSLocalizedString(@"UserFormUsernamePlaceholder", nil) forKey:@"textField.placeholder"];
    usernameRow.required = YES;
    usernameRow.requireMsg = NSLocalizedString(@"UserFormUsernameRequiredMessage", nil);
    [section addFormRow:usernameRow];
    
    XLFormRowDescriptor *passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword];
    [passwordRow.cellConfigAtConfigure setObject:NSLocalizedString(@"UserFormPasswordPlaceholder", nil) forKey:@"textField.placeholder"];
    passwordRow.required = YES;
    passwordRow.requireMsg = NSLocalizedString(@"UserFormPasswordRequiredMessage", nil);
    [section addFormRow:passwordRow];
}

@end

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
#import "NSDictionary+XLForm.h"
#import "NSError+AFNetworking.h"
#import <AFNetworking/AFURLResponseSerialization.h>


@interface SignUpViewController ()

@end

@implementation SignUpViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setupForm];
    [super viewDidLoad];
}



#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUp:(id)sender {
    
    // validate
    NSArray *validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    // end editing
    [self.tableView endEditing:NO];
    
    // create user
    NSDictionary *formValues = [[self formValues] dictionaryWithoutNulls];
    User *user = [[User alloc] init];
    [user updateWithDictionary:formValues];
    
    // show progress indicator
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    // sign up using the session manager
    __weak SignUpViewController *selfBlockRef = self;
    [[SessionManager sharedInstance] signUpWithUser:user success:^(User *user) {
        [progressHUD dismissAnimated:YES];
        [selfBlockRef performSegueWithIdentifier:@"ShowJogsFromSignUp" sender:nil];
    } fail:^(NSError *error) {
        
        NSLog(@"Can't sign up: %@", error);
        
        [progressHUD dismissAnimated:YES];
        
        NSString *title = nil;
        NSString *message = nil;
        
        // check for network error
        if([error isNetworkError]){
            title = NSLocalizedString(@"NoConnectionAlertTitle", nil);
            message = NSLocalizedString(@"NoConnectionAlertMessage", nil);
        }
        else{
            // check duplicated username or email
            NSDictionary *userInfo = [error userInfo];
            NSHTTPURLResponse *response = userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            if(response && response.statusCode == 400){
                NSData *responseData = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if(responseData){
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    int code = [responseDic[@"code"] intValue];
                    if(code == 202 || code == 203){
                        title = NSLocalizedString(@"BadSignUpDataAlertTitle", nil);
                        message = responseDic[@"error"];
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
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}


#pragma mark - Helpers

- (void)setupForm
{
    self.form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"SignUpFormTitle", nil)];
    self.form.assignFirstResponderOnShow = YES;
    
    // section
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [self.form addFormSection:section];
    
    // rows
    XLFormRowDescriptor *nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText];
    [nameRow.cellConfigAtConfigure setObject:NSLocalizedString(@"UserFormNamePlaceholder", nil) forKey:@"textField.placeholder"];
    [section addFormRow:nameRow];
    
    XLFormRowDescriptor *usernameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"username" rowType:XLFormRowDescriptorTypeText];
    [usernameRow.cellConfigAtConfigure setObject:NSLocalizedString(@"UserFormUsernamePlaceholder", nil) forKey:@"textField.placeholder"];
    usernameRow.required = YES;
    usernameRow.requireMsg = NSLocalizedString(@"UserFormUsernameRequiredMessage", nil);
    [section addFormRow:usernameRow];
    
    XLFormRowDescriptor *emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail];
    [emailRow.cellConfigAtConfigure setObject:NSLocalizedString(@"UserFormEmailPlaceholder", nil) forKey:@"textField.placeholder"];
    [emailRow addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:emailRow];
    
    XLFormRowDescriptor *passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword];
    [passwordRow.cellConfigAtConfigure setObject:NSLocalizedString(@"UserFormPasswordPlaceholder", nil) forKey:@"textField.placeholder"];
    passwordRow.required = YES;
    passwordRow.requireMsg = NSLocalizedString(@"UserFormPasswordRequiredMessage", nil);
    [section addFormRow:passwordRow];
    
}

@end

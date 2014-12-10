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
    } fail:^(NSError *user) {
        // TODO: check internet connection and expected API errors
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't sign up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [progressHUD dismissAnimated:YES];
    }];
}


#pragma mark - Helpers

- (void)setupForm
{
    self.form = [XLFormDescriptor formDescriptorWithTitle:@"Sign Up"];
    self.form.assignFirstResponderOnShow = YES;
    
    // section
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [self.form addFormSection:section];
    
    // rows
    XLFormRowDescriptor *nameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText];
    [nameRow.cellConfigAtConfigure setObject:@"Name" forKey:@"textField.placeholder"];
    [section addFormRow:nameRow];
    
    XLFormRowDescriptor *usernameRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"username" rowType:XLFormRowDescriptorTypeText];
    [usernameRow.cellConfigAtConfigure setObject:@"Username" forKey:@"textField.placeholder"];
    usernameRow.required = YES;
    usernameRow.requireMsg = @"Username can't be empty";
    [section addFormRow:usernameRow];
    
    XLFormRowDescriptor *emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail];
    [emailRow.cellConfigAtConfigure setObject:@"E-Mail" forKey:@"textField.placeholder"];
    [emailRow addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:emailRow];
    
    XLFormRowDescriptor *passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword];
    [passwordRow.cellConfigAtConfigure setObject:@"Password" forKey:@"textField.placeholder"];
    passwordRow.required = YES;
    passwordRow.requireMsg = @"Password can't be empty";
    [section addFormRow:passwordRow];
    
}

@end

//
//  NewJogViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "EditJogViewController.h"
#import "JogManager.h"
#import "SessionManager.h"
#import <JGProgressHUD/JGProgressHUD.h>


@interface EditJogViewController ()

@end

@implementation EditJogViewController

- (void)viewDidLoad
{
    [self setupForm];
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveJog)];
}

- (void)setupForm
{
    self.form = [self createForm];
}

- (XLFormDescriptor*)createForm
{
    // TODO: add validation
    
    // form
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Add Jog"];
    
    // section
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // time rows
    // TODO: use a double picker
    XLFormRowDescriptor *hoursRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"hours" rowType:XLFormRowDescriptorTypeInteger title:@"Hours"];
    [section addFormRow:hoursRow];
    XLFormRowDescriptor *minutesRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"minutes" rowType:XLFormRowDescriptorTypeInteger title:@"Minutes"];
    [section addFormRow:minutesRow];
    XLFormRowDescriptor *secondsRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"seconds" rowType:XLFormRowDescriptorTypeInteger title:@"Seconds"];
    [section addFormRow:secondsRow];
    
    // distance row
    XLFormRowDescriptor *distanceRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"distance" rowType:XLFormRowDescriptorTypeInteger title:@"Distance"];
    [distanceRow.cellConfigAtConfigure setObject:@"in meters" forKey:@"textField.placeholder"];
    distanceRow.required = YES;
    [section addFormRow:distanceRow];
    
    // date row
    XLFormRowDescriptor *dateRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"date" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Date"];
    dateRow.required = YES;
    dateRow.value = [NSDate date];
    [section addFormRow:dateRow];
    
    return form;
}


- (void)saveJog
{
    // validate form
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    
    // create jog
    NSDictionary *formValues = [self.form formValues];
    Jog *jog = [self newJogWithFormValues:formValues];
    
    // show progress HUD
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    // save jog
    [[JogManager sharedInstance] postJog:jog success:^(Jog *jog) {
        [self.delegate didSaveJog:jog];
        [progressHUD dismissAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        [progressHUD dismissAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't save jog right now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (int)timeFromFormValues:(NSDictionary*)formValues
{
    int time = 0;
    NSNumber *hours = formValues[@"hours"];
    if(hours && [hours isKindOfClass:[NSNumber class]]){
        time += [hours intValue]*60*60;
    }
    NSNumber *minutes = formValues[@"minutes"];
    if(minutes && [minutes isKindOfClass:[NSNumber class]]){
        time += [minutes intValue]*60;
    }
    NSNumber *seconds = formValues[@"seconds"];
    if(seconds && [seconds isKindOfClass:[NSNumber class]]){
        time += [seconds intValue];
    }
    return time;
}

- (Jog*)newJogWithFormValues:(NSDictionary*)formValues
{
    Jog *jog = [[Jog alloc] init];
    int time = [self timeFromFormValues:formValues];
    jog.time = @(time);
    jog.distance = formValues[@"distance"];
    jog.date = formValues[@"date"];
    jog.userId = [SessionManager sharedInstance].user.objectId;
    return jog;
}

@end

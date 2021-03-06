//
//  EditJogViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "EditJogViewController.h"
#import "JogManager.h"
#import "SessionManager.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "NSError+AFNetworking.h"
#import <AFNetworking/AFURLResponseSerialization.h>
#import "Logging.h"


@implementation EditJogViewController

- (void)viewDidLoad
{
    [self setupForm];
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveJog)];
}

- (void)setupForm
{
    self.form = [self createForm];
}

- (XLFormDescriptor*)createForm
{
    // form
    NSString *title = self.jog ? NSLocalizedString(@"EditJogFormTitle", nil) : NSLocalizedString(@"NewJogFormTitle", nil);
    
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:title];
    
    // section
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // time rows
    XLFormRowDescriptor *hoursRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"hours" rowType:XLFormRowDescriptorTypeInteger title:NSLocalizedString(@"JogFormHoursTitle", nil)];
    hoursRow.value = [self.jog hours] > 0 ? @([self.jog hours]) : nil;
    [section addFormRow:hoursRow];
    XLFormRowDescriptor *minutesRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"minutes" rowType:XLFormRowDescriptorTypeInteger title:NSLocalizedString(@"JogFormMinutesTitle", nil)];
    minutesRow.value = [self.jog minutes] > 0 ? @([self.jog minutes]) : nil;
    [section addFormRow:minutesRow];
    XLFormRowDescriptor *secondsRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"seconds" rowType:XLFormRowDescriptorTypeInteger title:NSLocalizedString(@"JogFormSecondsTitle", nil)];
    secondsRow.value = [self.jog seconds] ? @([self.jog seconds]) : nil;
    [section addFormRow:secondsRow];
    
    // distance row
    XLFormRowDescriptor *distanceRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"distance" rowType:XLFormRowDescriptorTypeInteger title:NSLocalizedString(@"JogFormDistanceTitle", nil)];
    [distanceRow.cellConfigAtConfigure setObject:NSLocalizedString(@"JogFormDistancePlaceholder", nil) forKey:@"textField.placeholder"];
    distanceRow.required = YES;
    distanceRow.value = self.jog.distance;
    [section addFormRow:distanceRow];
    
    // date row
    XLFormRowDescriptor *dateRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"date" rowType:XLFormRowDescriptorTypeDateTimeInline title:NSLocalizedString(@"JogFormDateTitle", nil)];
    dateRow.required = YES;
    dateRow.value = self.jog.date ?: [NSDate date];
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
    
    // show progress HUD
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    // setup blocks
    void (^success)(Jog *jog) = ^void(Jog *jog){
        [self.delegate didSaveJog:jog];
        [progressHUD dismissAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    };
    void (^fail)(NSError *error) = ^void(NSError *error){
        
        [progressHUD dismissAnimated:YES];
        
        DDLogError(@"Can't save jog: %@", error);
        
        NSString *title = nil;
        NSString *message = nil;
        if([error isNetworkError]){
            title = NSLocalizedString(@"NoConnectionAlertTitle", nil);
            message = NSLocalizedString(@"NoConnectionAlertMessage", nil);
        }
        else{
            title = NSLocalizedString(@"UnexpectedErrorAlertTitle", nil);
            message = NSLocalizedString(@"UnexpectedErrorAlertMessage", nil);
        }
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OKButtonTitle", nil) otherButtonTitles:nil] show];
    };
    
    // create jog
    NSDictionary *formValues = [self.form formValues];
    if(self.jog){
        [self updateJog:self.jog withFormValues:formValues];
        [[JogManager sharedInstance] updateJog:self.jog success:success fail:fail];
    }
    else{
        Jog *jog = [self newJogWithFormValues:formValues];
        jog.userId = [SessionManager sharedInstance].user.objectId;
        [[JogManager sharedInstance] postJog:jog success:success fail:fail];
    }
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
    [self updateJog:jog withFormValues:formValues];
    return jog;
}

- (void)updateJog:(Jog*)jog withFormValues:(NSDictionary*)formValues
{
    int time = [self timeFromFormValues:formValues];
    jog.time = @(time);
    jog.distance = formValues[@"distance"];
    jog.date = formValues[@"date"];
}

@end

//
//  NewJogViewControllerTests.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/5/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EditJogViewController.h"
#import "Jog.h"


@interface EditJogViewControllerTests : XCTestCase

- (BOOL)compareJog:(Jog *)jog withFormValues:(NSDictionary*)formValues;

@end

@implementation EditJogViewControllerTests

- (void)testTimeFromFormValues
{

    EditJogViewController *vc = [EditJogViewController new];
    XCTAssert([vc timeFromFormValues:nil] == 0);
    XCTAssert([vc timeFromFormValues:@{}] == 0);
    NSDictionary *dic = @{@"hours": [NSNull null], @"minutes": [NSNull null], @"seconds": [NSNull null]};
    XCTAssert([vc timeFromFormValues:dic] == 0);
    dic = @{@"seconds": @(20)};
    XCTAssert([vc timeFromFormValues:dic] == 20);
    dic = @{@"seconds": @(20), @"minutes": @(30), @"hours": @(2)};
    XCTAssert([vc timeFromFormValues:dic] == 20 + 30*60 + 2*60*60);
}


- (void)testCreateForm
{
    EditJogViewController *vc = [EditJogViewController new];
    XLFormDescriptor *formDescriptor = [vc createForm];
    XCTAssert([formDescriptor.formSections count] == 1);
    
    XLFormSectionDescriptor *section = formDescriptor.formSections[0];
    XCTAssert([section.formRows count] == 5);
    
    XLFormRowDescriptor *hoursRow = section.formRows[0];
    XCTAssert([hoursRow.title isEqualToString:@"Hours"]);
    XCTAssert(hoursRow.rowType == XLFormRowDescriptorTypeInteger);
    XCTAssert([hoursRow.tag isEqualToString:@"hours"]);
    
    XLFormRowDescriptor *minutesRow = section.formRows[1];
    XCTAssert([minutesRow.title isEqualToString:@"Minutes"]);
    XCTAssert(minutesRow.rowType == XLFormRowDescriptorTypeInteger);
    XCTAssert([minutesRow.tag isEqualToString:@"minutes"]);
    
    XLFormRowDescriptor *secondsRow = section.formRows[2];
    XCTAssert([secondsRow.title isEqualToString:@"Seconds"]);
    XCTAssert(secondsRow.rowType == XLFormRowDescriptorTypeInteger);
    XCTAssert([secondsRow.tag isEqualToString:@"seconds"]);
    
    XLFormRowDescriptor *distanceRow = section.formRows[3];
    XCTAssert([distanceRow.title isEqualToString:@"Distance"]);
    XCTAssert(distanceRow.rowType == XLFormRowDescriptorTypeInteger);
    XCTAssert([distanceRow.tag isEqualToString:@"distance"]);
    XCTAssert(distanceRow.required);
    
    XLFormRowDescriptor *dateRow = section.formRows[4];
    XCTAssert([dateRow.title isEqualToString:@"Date"]);
    XCTAssert(dateRow.rowType == XLFormRowDescriptorTypeDateTimeInline);
    XCTAssert([dateRow.tag isEqualToString:@"date"]);
}


- (void)testSetupForm
{
    EditJogViewController *vc = [EditJogViewController new];
    [vc setupForm];
    XCTAssert(vc.form);
}


- (void)testNewJogWithFormValues
{
    EditJogViewController *vc = [EditJogViewController new];
    Jog *jog = [vc newJogWithFormValues:@{}];
    XCTAssert(jog);
    XCTAssert([self compareJog:jog withFormValues:@{}]);
    
    NSDictionary *formValues = @{
        @"hours": @(1),
        @"minutes": @(2),
        @"seconds": @(3),
        @"time": @(4),
        @"date": [NSDate date],
    };
    
    jog = [vc newJogWithFormValues:formValues];
    XCTAssert(jog);
    XCTAssert([self compareJog:jog withFormValues:formValues]);
}


- (void)testUpdateJogWithFormValues
{
    EditJogViewController *vc = [EditJogViewController new];
    Jog *jog = [Jog new];
    XCTAssert([self compareJog:jog withFormValues:@{}]);
    
    NSDictionary *formValues = @{
        @"hours": @(1),
        @"minutes": @(2),
        @"seconds": @(3),
        @"time": @(4),
        @"date": [NSDate date],
    };
    
    [vc updateJog:jog withFormValues:formValues];
    XCTAssert([self compareJog:jog withFormValues:formValues]);
}

- (BOOL)compareJog:(Jog *)jog withFormValues:(NSDictionary*)formValues
{
    
    if([jog.time intValue] != [[EditJogViewController new] timeFromFormValues:formValues]){
        return NO;
    }
    
    if([jog.distance intValue] != [formValues[@"distance"] intValue]){
        return NO;
    }
    
    if(((jog.date && !formValues[@"date"]) || (!jog.date && formValues[@"date"]))){
        return NO;
    }
    
    if(jog.date && ![jog.date isEqual:formValues[@"date"]]){
        return NO;
    }
    
    return YES;
}

@end

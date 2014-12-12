//
//  FiltersViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/9/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "FiltersViewController.h"
#import <XLForm/XLForm.h>
#import "NSDictionary+XLForm.h"


@interface FiltersViewController ()

@end

@implementation FiltersViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [self setupFormWithFilters:self.filters];
    [super viewDidLoad];
}


#pragma mark - Form setup

- (void)setupFormWithFilters:(NSDictionary*)filters
{
    // setup form
    self.form = [XLFormDescriptor formDescriptorWithTitle:NSLocalizedString(@"FiltersFormTitle", nil)];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"FiltersFormDatesSectionTitle", nil)];
    [self.form addFormSection:section];
    
    XLFormRowDescriptor *fromRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"from" rowType:XLFormRowDescriptorTypeDateTimeInline title:NSLocalizedString(@"FiltersFormInitialDateTitle", nil)];
    fromRow.value = filters[@"from"];
    [section addFormRow:fromRow];
    
    XLFormRowDescriptor *toRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"to" rowType:XLFormRowDescriptorTypeDateTime title:NSLocalizedString(@"FiltersFormEndDateTitle", nil)];
    toRow.value = filters[@"to"];
    [section addFormRow:toRow];
    
    // setup navigation
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ClearFiltersTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    self.navigationItem.rightBarButtonItems = @[done, clear];
}


#pragma mark - Navigation

- (void)done
{
    // remove NSNull values
    NSDictionary *formValues = [[self.form formValues] dictionaryWithoutNulls];
    
    // notify delegate
    [self.delegate filtersViewController:self didApplyFilters:formValues];
}

- (void)clear
{
    [self.delegate filtersViewController:self didApplyFilters:nil];
}


@end

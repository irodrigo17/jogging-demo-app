//
//  EditJogViewController.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/4/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>


@class Jog;


@protocol EditJogViewControllerDelegate <NSObject>

@required

- (void)didSaveJog:(Jog*)jog;

@end



@interface EditJogViewController : XLFormViewController

@property (weak, nonatomic) id<EditJogViewControllerDelegate> delegate;

/**
 * The jog to edit, if nil then a new jog is being created.
 */
@property (strong, nonatomic) Jog *jog;


/**
 * Calculate jog time in seconds from the given form values.
 */
- (int)timeFromFormValues:(NSDictionary*)formValues;

/**
 * Creates the form descriptor.
 * Form descriptor has time fields (hours, minutes and seconds), a distance field and a date field.
 */
- (XLFormDescriptor*)createForm;

/**
 * Creates a form and sets it to the receivers form property.
 */
- (void)setupForm;


/**
 * Creates a new jog instance and updates it with the given form values.
 */
- (Jog*)newJogWithFormValues:(NSDictionary*)formValues;


/**
 * Updates the given jog with the given form values.
 */
- (void)updateJog:(Jog*)jog withFormValues:(NSDictionary*)formValues;

@end

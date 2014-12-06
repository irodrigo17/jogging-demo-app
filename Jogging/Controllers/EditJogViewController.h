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
@property (strong, nonatomic) Jog *jog;

// TODO: document me
- (int)timeFromFormValues:(NSDictionary*)formValues;

- (XLFormDescriptor*)createForm;

- (void)setupForm;

- (Jog*)newJogWithFormValues:(NSDictionary*)formValues;
- (void)updateJog:(Jog*)jog withFormValues:(NSDictionary*)formValues;

@end

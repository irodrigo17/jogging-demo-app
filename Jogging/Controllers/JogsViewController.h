//
//  JogsViewController.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "EditJogViewController.h"
#import "FiltersViewController.h"


@interface JogsViewController : UITableViewController <EditJogViewControllerDelegate, FiltersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *user;

@property (strong, nonatomic) NSMutableArray *jogs;


/**
 * Updates the username on the view for the given user.
 */
- (void)updateUsernameWithUser:(User*)user;


@end

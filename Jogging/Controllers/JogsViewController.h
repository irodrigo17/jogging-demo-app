//
//  JogsViewController.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface JogsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *user;

@property (strong, nonatomic) NSArray *jogs;


/**
 * Fetch jogs for the given user from the API and reload the table view.
 */
- (void)updateJogsWithUser:(User*)user;

/**
 * Updates the username on the view for the given user.
 */
- (void)updateUsernameWithUser:(User*)user;

/**
 * Reload the table view with the given jogs.
 */
- (void)reloadTableWithJogs:(NSArray*)jogs;

@end

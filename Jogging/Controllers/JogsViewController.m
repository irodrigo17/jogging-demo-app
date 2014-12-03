//
//  JogsViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "JogsViewController.h"
#import "JogManager.h"
#import "SessionManager.h"
#import "JogCell.h"


@interface JogsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *user;
@property (strong, nonatomic) NSArray *jogs;

/**
 * Fetch jogs for the current user from the API and reload the table view.
 */
- (void)updateJogs;

/**
 * Reload the table view with the given jogs.
 */
- (void)reloadTableWithJogs:(NSArray*)jogs;

@end


@implementation JogsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateJogs];
}


#pragma mark - API actions


- (void)updateJogs
{
    User *user = [SessionManager sharedInstance].user;
    [[JogManager sharedInstance] getAllJogsForUser:user success:^(NSArray *jogs) {
        [self reloadTableWithJogs:jogs];
    } fail:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Can't get jogs right now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self reloadTableWithJogs:nil];
    }];
}

- (void)reloadTableWithJogs:(NSArray *)jogs
{
    self.jogs = jogs;
    [self.tableView reloadData];
}


#pragma mark - Actions

- (IBAction)signOut:(id)sender {
    // TODO: update root view controller to avoid keeping uneccessary view controllers in the stack.
    UIViewController *vc = [self.storyboard instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // if there are no jogs there is a cell to communicates it to the user
    return [self.jogs count] ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JogCell *cell = [tableView dequeueReusableCellWithIdentifier:kJogCellReuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[JogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJogCellReuseIdentifier];
    }
    
    if([self.jogs count]){
        Jog *jog = self.jogs[indexPath.row];
        [cell updateWithJog:jog];
    }
    else{
        [cell updateWithJog:nil];
    }
    
    return cell;
}


@end

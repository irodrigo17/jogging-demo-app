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


@end


@implementation JogsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    User *user = [SessionManager sharedInstance].user;
    [self updateUsernameWithUser:user];
    [self updateJogsWithUser:user];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[NewJogViewController class]]){
        NewJogViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


#pragma mark - Private interface

- (void)setupTableView
{
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)handleRefresh:(UIRefreshControl*)refreshControl
{
    [self updateJogsForCurrentUser];
}

- (void)updateJogsForCurrentUser
{
    User *user = [SessionManager sharedInstance].user;
    [self updateJogsWithUser:user];
}

#pragma mark - Public infterface


- (void)updateJogsWithUser:(User*)user
{
    [[JogManager sharedInstance] getAllJogsForUser:user success:^(NSArray *jogs) {
        [self reloadTableWithJogs:jogs];
        if(self.refreshControl.refreshing){
            [self.refreshControl endRefreshing];
        }
    } fail:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Can't get jogs right now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self reloadTableWithJogs:nil];
        if(self.refreshControl.refreshing){
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)updateUsernameWithUser:(User *)user
{
    self.user.text = [NSString stringWithFormat:@"Signed in as %@", user.username];
}

- (void)reloadTableWithJogs:(NSArray *)jogs
{
    self.jogs = jogs;
    [self.tableView reloadData];
}


#pragma mark - Actions

- (IBAction)signOut:(id)sender {
    [[SessionManager sharedInstance] signOut];
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Avoid getting extra lines on the screen
    return [UIView new];
}


#pragma mark - NewJogViewControllerDelegate

- (void)didSaveJog:(Jog *)jog
{
    [self updateJogsForCurrentUser];
}


@end

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
#import <JGProgressHUD/JGProgressHUD.h>
#import "AppDelegate.h"


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
    if([segue.destinationViewController isKindOfClass:[EditJogViewController class]]){
        EditJogViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        if([sender isKindOfClass:[Jog class]]){
            vc.jog = sender;
        }
    }
}


#pragma mark - Private interface

- (void)setupTableView
{
    // setup edit button
    self.editing = NO;
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
    
    // setup refresh control
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
    [[JogManager sharedInstance] getAllJogsForUser:user success:^(NSMutableArray *jogs) {
        [self reloadTableWithJogs:jogs];
    } fail:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Can't get jogs right now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self reloadTableWithJogs:nil];
    }];
}

- (void)updateUsernameWithUser:(User *)user
{
    self.user.text = [NSString stringWithFormat:@"Signed in as %@", user.username];
}

- (void)reloadTableWithJogs:(NSMutableArray *)jogs
{
    // end editing if needed
    if([self isEditing]){
        [self setEditing:NO animated:YES];
    }
    
    // store jogs
    self.jogs = jogs;
    
    // reload data
    [self.tableView reloadData];
    
    // update refresh control state if needed
    if(self.refreshControl.refreshing){
        [self.refreshControl endRefreshing];
    }
}

- (void)deleteJog:(Jog*)jog
{
    JGProgressHUD *progressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view];
    
    [[JogManager sharedInstance] deleteJog:jog success:^(Jog *jog){
        NSLog(@"Deleted jog: %@", jog);
        [progressHUD dismiss];
    } fail:^(NSError *error){
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't delete jog" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        NSLog(@"Can't delete jog: %@\nError: %@", jog, error);
        [self updateJogsForCurrentUser];
        [progressHUD dismiss];
    }];
}


#pragma mark - Actions

- (IBAction)signOut:(id)sender {
    [[SessionManager sharedInstance] signOut];
    UIViewController *landingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:landingVC animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.jogs count] > 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.jogs count] > 0 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        JogCell *cell = (JogCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self.jogs removeObject:cell.jog];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self deleteJog:cell.jog];
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Avoid getting extra lines on the screen
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.jogs count] > 0){
        JogCell *cell = (JogCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"ShowEditJogViewController" sender:cell.jog];
    }
}


#pragma mark - NewJogViewControllerDelegate

- (void)didSaveJog:(Jog *)jog
{
    [self updateJogsForCurrentUser];
}


@end

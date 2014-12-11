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
#import "NSError+AFNetworking.h"


static const NSInteger kLimit = 50;


@interface JogsViewController ()

/**
 * The number of jogs to skip in the next fetch.
 */
@property (assign, nonatomic) NSInteger skip;

@property (assign, nonatomic) BOOL noMoreJogs;

@property (strong, nonatomic) NSDictionary *filters;

@end


@implementation JogsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    User *user = [SessionManager sharedInstance].user;
    [self updateUsernameWithUser:user];
    [self loadFirstJogsForCurrentUser];
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
    else if([segue.destinationViewController isKindOfClass:[FiltersViewController class]]){
        FiltersViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.filters = self.filters;
    }
}


#pragma mark - Initialization

- (void)setupTableView
{   
    // setup refresh control
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    // setup navigation
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"FilterButtonTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showFilters)];
    UIBarButtonItem *stats = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"StatsButtonTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showStats)];
    self.navigationItem.leftBarButtonItems = @[filter, stats];
}

- (void)updateUsernameWithUser:(User *)user
{
    self.user.text = [NSString stringWithFormat:NSLocalizedString(@"SignedInUsernameFormatString", nil), user.username];
}

#pragma mark - Loading jogs

- (void)loadJogsWithUser:(User*)user filters:(NSDictionary*)filters initial:(BOOL)initial
{
    
    // end editing if needed
    if([self isEditing]){
        [self setEditing:NO animated:YES];
    }
    
    // initial setup
    if(initial){
        self.noMoreJogs = NO;
        self.skip = 0;
        // update refresh control state if needed
        if(!self.refreshControl.refreshing){
            [self.refreshControl beginRefreshing];
        }
    }
    
    // store filters
    self.filters = filters;
    
    // get jogs
    [[JogManager sharedInstance] getJogsForUser:user limit:kLimit skip:self.skip filters:filters success:^(NSMutableArray *jogs){
        
        if([jogs count] < kLimit){
            self.noMoreJogs = YES;
        }
        self.skip += [jogs count];
        
        if(initial){
            [self reloadTableWithJogs:jogs];
            // update refresh control state if needed
            if(self.refreshControl.refreshing){
                [self.refreshControl endRefreshing];
            }
        }
        else{
            [self appendJogs:jogs];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Can't get jogs: %@", error);
        
        // end refreshing if needed
        if(self.refreshControl.refreshing){
            [self.refreshControl endRefreshing];
        }
        
        // check error
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
        
        // reset jogs
        self.skip = 0;
        [self reloadTableWithJogs:nil];
    }];
}

- (void)loadFirstJogsForCurrentUser
{
    User *user = [SessionManager sharedInstance].user;
    [self loadJogsWithUser:user filters:nil initial:YES];
}

- (void)loadNextJogsForCurrentUser
{
    User *user = [SessionManager sharedInstance].user;
    [self loadJogsWithUser:user filters:self.filters initial:NO];
}


#pragma mark - Deleting jogs

- (void)deleteJog:(Jog*)jog success:(void (^)())success
{
    JGProgressHUD *progressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    [[JogManager sharedInstance] deleteJog:jog success:^(Jog *jog){
        NSLog(@"Deleted jog: %@", jog);
        [progressHUD dismissAnimated:YES];
        success();
    } fail:^(NSError *error){
        
        [progressHUD dismissAnimated:YES];
        
        NSLog(@"Can't delete jog: %@", error);

        // check error
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
        
    }];
}

#pragma mark - Updating UI

- (void)handleRefresh:(UIRefreshControl*)refreshControl
{
    [self loadFirstJogsForCurrentUser];
}

- (void)reloadTableWithJogs:(NSMutableArray *)jogs
{
    self.jogs = jogs;
    [self.tableView reloadData];
}

- (void)appendJogs:(NSMutableArray*)jogs
{
    if(!self.jogs){
        self.jogs = [NSMutableArray array];
    }
    
    NSUInteger prevCount = [self.jogs count];
    [self.jogs addObjectsFromArray:jogs];
    
    NSMutableArray *indexes = [NSMutableArray array];
    for (NSUInteger i = prevCount; i < [self.jogs count]; i++) {
        NSIndexPath *indexPath= [NSIndexPath indexPathForRow:i inSection:0];
        [indexes addObject:indexPath];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Actions

- (IBAction)signOut:(id)sender {
    [[SessionManager sharedInstance] signOut];
    UIViewController *landingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:landingVC animated:YES];
}


#pragma mark - Navigation

- (void)showFilters
{
    [self performSegueWithIdentifier:@"ShowFilters" sender:nil];
}

- (void)showStats
{
    [self performSegueWithIdentifier:@"ShowStats" sender:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.jogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JogCell *cell = [tableView dequeueReusableCellWithIdentifier:kJogCellReuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[JogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJogCellReuseIdentifier];
    }
    
    Jog *jog = self.jogs[indexPath.row];
    [cell updateWithJog:jog];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.jogs && [self.jogs count] == 0 ? NSLocalizedString(@"NoJogsMessage", nil) : nil;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        JogCell *cell = (JogCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self deleteJog:cell.jog success:^{
            [self.jogs removeObject:cell.jog];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if([self.jogs count] == 0){
                [self.tableView reloadData];
            }
        }];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.noMoreJogs && indexPath.row == [self.jogs count] - 1){
        // load more jogs
        // TODO: show activity indicator?
        [self loadNextJogsForCurrentUser];
    }
}

#pragma mark - NewJogViewControllerDelegate

- (void)didSaveJog:(Jog *)jog
{
    [self loadFirstJogsForCurrentUser];
}


#pragma mark - FiltersViewControllerDelegate

- (void)filtersViewControllerDidCancel:(FiltersViewController *)viewController
{
    [self.navigationController popToViewController:self animated:YES];
}

- (void)filtersViewController:(FiltersViewController *)viewController didApplyFilters:(NSDictionary *)filters
{
    [self.navigationController popToViewController:self animated:YES];
    User *user = [SessionManager sharedInstance].user;
    [self loadJogsWithUser:user filters:filters initial:YES];
}

@end

//
//  StatsViewController.m
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/9/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import "StatsViewController.h"
#import "APIManager.h"
#import "SessionManager.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "NSDate+Parse.h"
#import "NSError+AFNetworking.h"
#import "WeeklyStats.h"
#import "Logging.h"


@interface StatsViewController ()

@end


@implementation StatsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"StatsTitle", nil);
    [self loadStats];
}


#pragma mark - Loading stats

- (void)loadStats
{
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    User *user = [SessionManager sharedInstance].user;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user"] = [user parsePointerDictionary];
    [[APIManager sharedInstance] POST:@"functions/report" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [progressHUD dismissAnimated:YES];
        self.stats = [NSMutableArray array];
        for(NSDictionary *week in responseObject[@"result"]){
            WeeklyStats *stats = [WeeklyStats new];
            [stats updateWithDictionary:week];
            [self.stats addObject:stats];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [progressHUD dismissAnimated:YES];
        
        DDLogError(@"Can't get stats: %@", error);
        
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


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MAX([self.stats count], 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stats count] ? 4 : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(!self.stats){
        return nil;
    }
    else if(![self.stats count]){
        return NSLocalizedString(@"NoJogsTitle", nil);
    }
    
    WeeklyStats *stats = self.stats[section];
    return [stats formattedDates];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatsCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsCell"];
    }
    
    WeeklyStats *stats = self.stats[indexPath.section];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"StatsAverageTime", nil);
            cell.detailTextLabel.text = [stats formattedAverageTime];
            break;
            
        case 1:
            cell.textLabel.text = NSLocalizedString(@"StatsAverageDistance", nil);
            cell.detailTextLabel.text = [stats formattedAverageDistance];
            break;
            
        case 2:
            cell.textLabel.text = NSLocalizedString(@"StatsAverageSpeed", nil);
            cell.detailTextLabel.text = [stats formattedAverageSpeed];
            break;
            
        case 3:
            cell.textLabel.text = NSLocalizedString(@"StatsTotalJogs", nil);
            cell.detailTextLabel.text = [stats.jogs stringValue];
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Avoid getting extra lines on the screen
    return [UIView new];
}

@end

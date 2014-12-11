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
#import "DateHelper.h"
#import "NSError+AFNetworking.h"


@interface StatsViewController ()

@end


@implementation StatsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Weekly Stats";
    [self loadStats];
}


#pragma mark - Loading stats

- (void)loadStats
{
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [progressHUD showInView:self.view animated:YES];
    
    User *user = [SessionManager sharedInstance].user;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // TODO: Encapsulate Parse User dictionary creation
    params[@"user"] = @{@"__type": @"Pointer", @"className": @"_User", @"objectId": user.objectId};
    [[APIManager sharedInstance] POST:@"functions/report" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [progressHUD dismissAnimated:YES];
        self.stats = responseObject[@"result"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [progressHUD dismissAnimated:YES];
        
        NSLog(@"Can't get stats: %@", error);
        
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
    return [self.stats count] ? 2 : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(!self.stats){
        return nil;
    }
    else if(![self.stats count]){
        return @"No jogs yet, go for a run!";
    }
    
    NSDictionary *stats = self.stats[section];
    
    NSDate *startDate = [DateHelper deserializeParseDate:stats[@"startDate"]];
    NSString *formattedStartDate = [[StatsViewController sharedDateFormatter] stringFromDate:startDate];
    
    NSDate *endDate = [DateHelper deserializeParseDate:stats[@"endDate"]];
    NSString *formattedEndDate = [[StatsViewController sharedDateFormatter] stringFromDate:endDate];

    return [NSString stringWithFormat:@"From %@ to %@", formattedStartDate, formattedEndDate];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatsCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsCell"];
    }
    
    NSDictionary *stats = self.stats[indexPath.section];
    int jogs = [stats[@"jogs"] intValue];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Avg Time";
            int time = [stats[@"time"] intValue];
            int averageTime = time / jogs;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i seconds", averageTime];
            break;
            
        case 1:
            cell.textLabel.text = @"Avg Distance";
            int distance = [stats[@"distance"] intValue];
            int averageDistance = distance / jogs;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i meters", averageDistance];
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


#pragma mark - Helpers

+ (NSDateFormatter*)sharedDateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSDateFormatter alloc] init];
        sharedInstance.dateStyle = NSDateFormatterShortStyle;
        sharedInstance.timeStyle = NSDateFormatterNoStyle;
    });
    return sharedInstance;
}

@end

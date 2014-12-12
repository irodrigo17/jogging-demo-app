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
    
    NSDictionary *stats = self.stats[section];
    
    NSDate *startDate = [NSDate dateWithParseDictionary:stats[@"startDate"]];
    NSString *formattedStartDate = [[StatsViewController sharedDateFormatter] stringFromDate:startDate];
    
    NSDate *endDate = [NSDate dateWithParseDictionary:stats[@"endDate"]];
    NSString *formattedEndDate = [[StatsViewController sharedDateFormatter] stringFromDate:endDate];

    return [NSString stringWithFormat:NSLocalizedString(@"StatsHeaderFormatString", nil), formattedStartDate, formattedEndDate];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatsCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatsCell"];
    }
    
    NSDictionary *stats = self.stats[indexPath.section];
    int jogs = [stats[@"jogs"] intValue];
    
    // TODO: create a model for weekly stats and encapsulate logic there
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"StatsAverageTime", nil);
            int time = [stats[@"time"] intValue];
            int averageTime = time / jogs / 60;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i minutes", averageTime];
            break;
            
        case 1:
            cell.textLabel.text = NSLocalizedString(@"StatsAverageDistance", nil);
            int distance = [stats[@"distance"] intValue];
            float averageDistance = (float)distance / (float)jogs / 1000.0f;
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatsDistanceFormatString", nil), averageDistance];
            break;
            
        case 2:
            cell.textLabel.text = NSLocalizedString(@"StatsAverageSpeed", nil);
            float averageSpeed = ([stats[@"distance"] floatValue] / 1000.0f) / ([stats[@"time"] floatValue] / 60.0f / 60.0f);
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"StatsSpeedFormatString", nil), averageSpeed];
            break;
            
        case 3:
            cell.textLabel.text = NSLocalizedString(@"StatsTotalJogs", nil);
            cell.detailTextLabel.text = [stats[@"jogs"] stringValue];
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

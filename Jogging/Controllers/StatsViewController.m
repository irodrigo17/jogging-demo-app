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
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't get stats" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        NSLog(@"Can't get stats: %@", error);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.stats count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
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

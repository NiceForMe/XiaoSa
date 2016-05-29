//
//  LXNewsLeftViewController.m
//  My App
//
//  Created by NiceForMe on 16/3/8.
//  Copyright © 2016年 NiCeForMe. All rights reserved.
//

#import "LXNewsLeftViewController.h"
#import "LXHistoryViewController.h"
#import "RESideMenu.h"
#import "LXTabBarController.h"
#import "LXNBAViewController.h"
@interface LXNewsLeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation LXNewsLeftViewController
- (NSArray *)titles
{
    if (!_titles) {
        _titles = [NSArray array];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"首页", @"历史上的今天",@"NBA赛事"];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * self.titles.count) / 2.0f, self.view.frame.size.width, 54 * self.titles.count) style:UITableViewStylePlain];
                tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}
#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[LXTabBarController alloc]init]animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[LXHistoryViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[LXNBAViewController alloc]init]] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


@end

//
//  LXHistoryViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/12.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXHistoryViewController.h"
#import "LXHistoryCell.h"
#import "LXHistoryModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "LXTabBarController.h"
#import "RESideMenu.h"
#import "LXNewsMainViewController.h"
#import <MJRefresh.h>
#import "LXDataManager.h"

@interface LXHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSMutableArray *dataList;
@end

@implementation LXHistoryViewController
#pragma mark - lazy load
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBasic];
    [self loadData];
}
#pragma mark - basic
- (void)setBasic
{
    self.title = @"历史上的今天";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.frame = self.view.frame;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[LXHistoryCell class] forCellReuseIdentifier:@"cellIdentifier"];
}
#pragma mark - loadData
- (void)loadData
{
    [self load];
    [self refresh];
}
#pragma mark - private
- (void)load
{
    [self addHud];
    //获取当前日期
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"MMdd"];
    NSString *dateString = [fmt stringFromDate:date];
    NSString *str = @"http://apicloud.mob.com/appstore/history/query?key=102cf88fe9318&day=";
    NSString *urlStr = [str stringByAppendingString:dateString];
    [[LXDataManager shareManager]getHistoryArrayWithURLString:urlStr success:^(NSArray *historyArray) {
        self.dataList = [NSMutableArray arrayWithArray:historyArray];
        [self.tableView reloadData];
        [self removeHud];
    } failed:^(NSError *error) {
        [self showError];
    }];
}
- (void)refresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //获得当前日期
        NSDate *date = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"MMdd"];
        NSString *dateString = [fmt stringFromDate:date];
        NSString *str = @"http://apicloud.mob.com/appstore/history/query?key=102cf88fe9318&day=";
        NSString *urlStr = [str stringByAppendingString:dateString];
        [[LXDataManager shareManager]getHistoryArrayWithURLString:urlStr success:^(NSArray *historyArray) {
            self.dataList = [NSMutableArray arrayWithArray:historyArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failed:^(NSError *error) {
            [self showError];
        }];
    }];
}
#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.tableView startAutoCellHeightWithCellClass:[LXHistoryCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXHistoryCell *cell = [LXHistoryCell cellWithTableView:tableView];
    if (self.dataList.count > 0) {
        cell.model = [self.dataList objectAtIndex:indexPath.row];
        cell.numberLable.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }else{
        
    }
    return cell;
}
#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataList[indexPath.row] keyPath:@"model"];
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

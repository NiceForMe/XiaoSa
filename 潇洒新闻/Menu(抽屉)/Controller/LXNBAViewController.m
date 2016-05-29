//
//  LXNBAViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/12.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNBAViewController.h"
#import "LXNBACell.h"
#import "LXNBAModel.h"
#import "UIView+SDAutoLayout.h"
#import <MJRefresh.h>
#import "LXDataManager.h"

#define Margin 10
#define LableWidth 50

@interface LXNBAViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) UILabel *dayLable;
@property (nonatomic,strong) UILabel *hourLable;
@property (nonatomic,strong) UILabel *minuteLable;
@property (nonatomic,strong) UILabel *secondLable;

@end

@implementation LXNBAViewController
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self loadData];
}
#pragma mark - basic
- (void)setupBasic
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"2015-2016赛季NBA常规赛";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    //tableview
    self.tableView = [[UITableView alloc]init];
    [self.tableView registerClass:[LXNBACell class] forCellReuseIdentifier:@"cellIdentifier"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(self.view.height);
    [self.tableView registerClass:[LXNBACell class] forCellReuseIdentifier:@"cellIdentifier"];
}
#pragma mark - loadData
- (void)loadData
{
    [self load];
    [self refresh];
}
#pragma mark - load
- (void)load
{
    [self addHud];
    [[LXDataManager shareManager]getNBAArrayWithURLString:@"http://op.juhe.cn/onebox/basketball/nba?key=6a04fb6c9c0aadc779c4ff5117f2d27e" success:^(NSArray *nbaArray) {
        self.dataList = [NSMutableArray arrayWithArray:nbaArray];
        [self.tableView reloadData];
        [self removeHud];
    } failed:^(NSError *error) {
        [self removeHud];
        [self showError];
    }];
}
#pragma mark - refresh
- (void)refresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[LXDataManager shareManager]getNBAArrayWithURLString:@"http://op.juhe.cn/onebox/basketball/nba?key=6a04fb6c9c0aadc779c4ff5117f2d27e" success:^(NSArray *nbaArray) {
            self.dataList = [NSMutableArray arrayWithArray:nbaArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failed:^(NSError *error) {
            
        }];
    }];
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXNBACell *cell = [LXNBACell cellWithTableView:tableView];
    if (self.dataList.count > 0) {
        cell.model = [self.dataList objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}


@end

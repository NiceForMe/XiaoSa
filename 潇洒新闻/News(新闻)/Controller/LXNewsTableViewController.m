//
//  LXNewsTableViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.

#import "LXNewsTableViewController.h"
#import "LXNewsDetailViewController.h"
#import "LXNewsNoPictureCell.h"
#import "LXNewsSinglePictureCell.h"
#import "LXNewsMultiPictureCell.h"
#import "LXNormalNews.h"
#import "LXJudgeNetworking.h"
#import "LXNormalNewsFetchDataParameter.h"
#import <SVProgressHUD.h>
#import "LXDataTool.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <MJExtension.h>
@interface LXNewsTableViewController ()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *normalNewsArray;
@end

static NSString * const singlePictureCell = @"SinglePictureCell";
static NSString * const multiPictureCell = @"MultiPictureCell";
static NSString * const noPictureCell = @"NoPictureCell";
static NSString * const apikey = @"093b458afaea17211d2eb6be9871e60c";

@implementation LXNewsTableViewController
#pragma mark - 懒加载
- (NSMutableArray *)normalNewsArray
{
    if (!_normalNewsArray) {
        _normalNewsArray = [NSMutableArray array];
    }
    return _normalNewsArray;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([LXJudgeNetworking judge] == NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        return;
    }
    [self setupBasic];
    [self setupRefresh];
}
#pragma mark - setupBasic
- (void)setupBasic
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LXNewsSinglePictureCell class]) bundle:nil] forCellReuseIdentifier:singlePictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LXNewsMultiPictureCell class]) bundle:nil] forCellReuseIdentifier:multiPictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LXNewsNoPictureCell class]) bundle:nil] forCellReuseIdentifier:noPictureCell];
}
#pragma mark - setupRefresh
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}
- (void)loadNewData
{
    [SVProgressHUD show];
    [self fetchNewNormalNews];
}
- (void)fetchNewNormalNews
{
    LXNormalNews *news = self.normalNewsArray.firstObject;
    LXNormalNewsFetchDataParameter *parameters = [[LXNormalNewsFetchDataParameter alloc]init];
    parameters.channelId = self.channelId;
    parameters.channelName = self.channelName;
    parameters.title = @", ";
    parameters.page = 1;
    parameters.recentTime = news.createdtime;
    [LXDataTool LXNormalNewsWithParameters:parameters success:^(NSMutableArray *array) {
        self.normalNewsArray = array;
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData
{
    [SVProgressHUD show];
    LXNormalNews *news = self.normalNewsArray.lastObject;
    if (self.currentPage >= news.allPages) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD showErrorWithStatus:@"全部加载完毕"];
        return;
    }
    NSInteger currentPage = self.currentPage + 1;
    LXNormalNewsFetchDataParameter *parameters = [[LXNormalNewsFetchDataParameter alloc]init];
    parameters.channelId = self.channelId;
    parameters.channelName = self.channelName;
    parameters.title = @":";
    parameters.page = currentPage;
    parameters.remoteTime = news.createdtime;
    [LXDataTool LXNormalNewsWithParameters:parameters success:^(NSMutableArray *array) {
        [self.normalNewsArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        self.currentPage = currentPage;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.normalNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXNormalNews *news = self.normalNewsArray[indexPath.row];
    if (news.normalNewsType == NormalNewsTypeMultiPicture) {
        LXNewsMultiPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
        cell.titleText = news.title;
        cell.imageUrls = news.imageurls;
        return cell;
    }else if (news.normalNewsType == NormalNewsTypeSigalPicture){
        LXNewsSinglePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
        cell.titleText = news.title;
        cell.contentText = news.desc;
        NSDictionary *dict = news.imageurls.firstObject;
        if (dict) {
            cell.imageUrl = dict[@"url"];
        }
        return cell;
    }else{
        LXNewsNoPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:noPictureCell];
        cell.titleText = news.title;
        cell.contentText = news.desc;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LXNormalNews *news = [self.normalNewsArray objectAtIndex:indexPath.row];
    LXNewsDetailViewController *detail = [[LXNewsDetailViewController alloc]init];
    [detail useWebViewWithURLString:news.link];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXNormalNews *news = self.normalNewsArray[indexPath.row];
    return news.cellHeight;
}

@end

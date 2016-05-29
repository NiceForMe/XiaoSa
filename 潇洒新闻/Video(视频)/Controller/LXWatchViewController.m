//
//  LXWatchViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/12.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXWatchViewController.h"
#import "LXWatchCollectionReusableView.h"
#import "LXWatchCollectionViewCell.h"
#import "AppDelegate.h"
#import "LXWatchDetailViewController.h"
#import "LXDataManager.h"
#import "LXWatchSidModel.h"
#import "LXWatchVideoModel.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define LXCellIdentifier @"Cell"
#define LXHeaderViewCell @"ReusableView"
#define LXFooterViewCell @"FooterView"

@interface LXWatchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *dataSource;
    NSIndexPath *currentIndexPath;
}
@property (nonatomic,strong) LXWatchCollectionViewCell *currentCell;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation LXWatchViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        dataSource = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UICollectionViewFlowLayout
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LXWidth, LXHeight) collectionViewLayout:flowLayout];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    //注册
    [self registerData];
    [self loadData];
    //添加刷新
    [self addMJRefresh];
}
#pragma mark - 加载数据
- (void)loadData
{
    [[LXDataManager shareManager]getSidArrayWithURLString:@"http://c.m.163.com/nc/video/home/0-10.html" success:^(NSArray *sidArray, NSArray *videoArray) {
        dataSource = [NSMutableArray arrayWithArray:videoArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        });
    } failed:^(NSError *error) {
        
    }];

}

#pragma mark - 注册
- (void)registerData
{
    [self.collectionView registerClass:[LXWatchCollectionViewCell class] forCellWithReuseIdentifier:LXCellIdentifier];
    [self.collectionView registerClass:[LXWatchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LXHeaderViewCell];
}

#pragma mark - addMJRefresh
- (void)addMJRefresh
{
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[LXDataManager shareManager]getSidArrayWithURLString:@"http://c.m.163.com/nc/video/home/0-10.html" success:^(NSArray *sidArray, NSArray *videoArray) {
            dataSource = [NSMutableArray arrayWithArray:videoArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            });
        } failed:^(NSError *error) {
            
        }];
    }];
    //设置自动切换透明度
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    //上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSString *urlString = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%lu-10.html",dataSource.count - dataSource.count % 10];
        [[LXDataManager shareManager]getSidArrayWithURLString:urlString success:^(NSArray *sidArray, NSArray *videoArray) {
            [dataSource addObjectsFromArray:videoArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.collectionView.mj_footer endRefreshing];
            });
        } failed:^(NSError *error) {
            
        }];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = LXCellIdentifier;
    LXWatchCollectionViewCell *cell = (LXWatchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        
    }
    cell.model = [dataSource objectAtIndex:indexPath.row];
    cell.playBtn.tag = indexPath.row;
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView  = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        LXWatchCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LXHeaderViewCell forIndexPath:indexPath];
        [headerView.firstView sd_setImageWithURL:[NSURL URLWithString:@"http://vimg3.ws.126.net/image/snapshot/2016/4/P/P/VBK2S00PP.jpg"]];
        [headerView.firstButton addTarget:self action:@selector(playVideo1) forControlEvents:UIControlEventTouchUpInside];
        [headerView.secondView sd_setImageWithURL:[NSURL URLWithString:@"http://vimg3.ws.126.net/image/snapshot/2016/4/U/O/VBK2QF2UO.jpg"]];
        [headerView.secondButton addTarget:self action:@selector(playVideo2) forControlEvents:UIControlEventTouchUpInside];
        [headerView.thirdView sd_setImageWithURL:[NSURL URLWithString:@"http://vimg1.ws.126.net/image/snapshot/2016/4/E/6/VBK3I3VE6.jpg"]];
        [headerView.thirdButton addTarget:self action:@selector(playVideo3) forControlEvents:UIControlEventTouchUpInside];
        reusableView = headerView;
    }
    return reusableView;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((LXWidth - 20)/2,100);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(LXWidth, 200);
    }else{
        return CGSizeMake(0, 0);
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//定义每个cell的纵向最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LXWatchVideoModel *model = [dataSource objectAtIndex:indexPath.row];
    LXWatchDetailViewController *detailVC = [[LXWatchDetailViewController alloc]init];
    detailVC.URLString = model.m3u8_url;
    detailVC.title = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 点击按钮开始播放

-(void)startPlayVideo:(UIButton *)sender
{
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    self.currentCell = (LXWatchCollectionViewCell *)sender.superview;
    LXWatchVideoModel *model = [dataSource objectAtIndex:sender.tag];
    LXWatchDetailViewController *detailVC = [[LXWatchDetailViewController alloc]init];
    detailVC.URLString = model.mp4_url;
    detailVC.title = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - headerview的点击播放

- (void)playVideo1
{
    LXWatchDetailViewController *detailVC  = [[LXWatchDetailViewController alloc]init];
    detailVC.URLString = @"http://flv2.bn.netease.com/videolib3/1604/19/NImiX8609/SD/movie_index.m3u8";
    detailVC.title = @"马来西亚美女5分钟化妆挑战";
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)playVideo2
{
    LXWatchDetailViewController *detailVC  = [[LXWatchDetailViewController alloc]init];
    detailVC.URLString = @"http://flv2.bn.netease.com/videolib3/1604/19/jnvde6885/SD/movie_index.m3u8";
    detailVC.title = @"歪果仁打造一个纯金属火柴盒";
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)playVideo3
{
    LXWatchDetailViewController *detailVC  = [[LXWatchDetailViewController alloc]init];
    detailVC.URLString = @"http://flv2.bn.netease.com/videolib3/1604/19/CBAaZ1298/SD/movie_index.m3u8";
    detailVC.title = @"意大利美少女:中国人爱问我";
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end

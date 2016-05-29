//
//  LXWatchDetailViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/12.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXWatchDetailViewController.h"
#import "LXPlayer.h"
#import "LXRecommondCollectionViewCell.h"
#import "LXRecommondCollectionViewFlowLayout.h"
#import "LXWatchSidModel.h"
#import "LXWatchVideoModel.h"
#import "LXDataManager.h"
#import "LXRecommondViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import <UIView+SDAutoLayout.h>
#import <SVProgressHUD.h>
static NSString *cellIdentifier = @"nice";

@interface LXWatchDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    LXPlayer *lxPlayer;
    NSMutableArray *dataSource;
    CGRect playerFrame;
}
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation LXWatchDetailViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        dataSource = [NSMutableArray array];
        //全屏播放通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fullScreenBtnClick:) name:LXPlayerFullScreenButtonClickedNotification object:nil];
        //屏幕旋转通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTipView];
    [self performSelector:@selector(loadData)];
}
- (void)loadData
{
    [self addHudToView:self.collectionView];
    [[LXDataManager shareManager]getSidArrayWithURLString:@"http://c.m.163.com/nc/video/home/0-10.html" success:^(NSArray *sidArray, NSArray *videoArray) {
        dataSource = [NSMutableArray arrayWithArray:videoArray];
        [self removeHud];
        [self.collectionView reloadData];
    } failed:^(NSError *error) {
        
    }];
}
- (void)initTipView
{
    //lxPlayer
    playerFrame = CGRectMake(0, 64, LXWidth, LXWidth * 3/5);
    lxPlayer = [[LXPlayer alloc]initWithFrame:playerFrame videoURLStr:self.URLString];
    [self.view addSubview:lxPlayer];
    [lxPlayer.player play];
    //tipview
    UIView *tipView = [[UIView alloc]init];
    tipView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tipView];
    tipView.sd_layout
    .widthIs(LXWidth)
    .heightIs(60)
    .topSpaceToView(lxPlayer,0);
    //tipLable
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = @"温馨提示:";
    titleLable.textColor = [UIColor blackColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [tipView addSubview:titleLable];
    titleLable.sd_layout
    .widthIs(LXWidth / 5)
    .heightIs(60)
    .leftSpaceToView(tipView,0);
    //firstlable
    UILabel *firstLable = [[UILabel alloc]init];
    firstLable.text = @"1.左右滑动屏幕可以快进或者后退";
    firstLable.textColor = [UIColor blackColor];
    firstLable.textAlignment = NSTextAlignmentLeft;
    [tipView addSubview:firstLable];
    firstLable.sd_layout
    .leftSpaceToView(titleLable,0)
    .rightSpaceToView(tipView,0)
    .topSpaceToView(tipView,0)
    .heightIs(tipView.frame.size.height / 3);
    //secondLable
    UILabel *secondLable = [[UILabel alloc]init];
    secondLable.text = @"2.滑动屏幕右侧可以调节亮度";
    secondLable.textColor = [UIColor blackColor];
    secondLable.textAlignment = NSTextAlignmentLeft;
    [tipView addSubview:secondLable];
    secondLable.sd_layout
    .leftEqualToView(firstLable)
    .rightEqualToView(firstLable)
    .topSpaceToView(firstLable,0)
    .heightIs(tipView.frame.size.height / 3);
    //thirdLable
    UILabel *thirdLable = [[UILabel alloc]init];
    thirdLable.text = @"3.滑动屏幕左侧可以调节音量";
    thirdLable.textColor = [UIColor blackColor];
    thirdLable.textAlignment = NSTextAlignmentLeft;
    [tipView addSubview:thirdLable];
    thirdLable.sd_layout
    .leftEqualToView(firstLable)
    .rightEqualToView(firstLable)
    .topSpaceToView(secondLable,0)
    .heightIs(tipView.frame.size.height / 3);
    //推荐lable
    UILabel *recommondView = [[UILabel alloc]init];
    recommondView.text = @"推荐观看";
    recommondView.font = [UIFont systemFontOfSize:25];
    recommondView.textAlignment = NSTextAlignmentCenter;
    recommondView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:recommondView];
    recommondView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(tipView,0)
    .heightIs(40);
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[LXRecommondCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(recommondView,0)
    .bottomSpaceToView(self.view,0);
}
#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXRecommondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (dataSource) {
        cell.model = [dataSource objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [lxPlayer.player pause];
    lxPlayer.playOrPauseBtn.selected = YES;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LXWatchVideoModel *model = [dataSource objectAtIndex:indexPath.row];
    LXRecommondViewController *recoVC = [[LXRecommondViewController alloc]init];
    recoVC.URLString = model.m3u8_url;
    recoVC.title = model.title;
    [self.navigationController pushViewController:recoVC animated:YES];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((LXWidth - 20) / 3, (LXWidth - 20) / 3);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - 全屏播放通知
- (void)fullScreenBtnClick:(NSNotification *)notice
{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}
//全屏
- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation
{
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [lxPlayer removeFromSuperview];
    lxPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        lxPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        lxPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    lxPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    lxPlayer.playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    [lxPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.height);
        make.top.mas_equalTo(self.view.frame.size.width - 40);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:lxPlayer];
    lxPlayer.isFullScreen = YES;
    lxPlayer.fullScreenBtn.selected = YES;
    [lxPlayer bringSubviewToFront:lxPlayer.bottomView];
}
//普通
- (void)toNormal
{
    [lxPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        lxPlayer.transform = CGAffineTransformIdentity;
        lxPlayer.frame = CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        lxPlayer.playerLayer.frame = lxPlayer.frame;
        [self.view addSubview:lxPlayer];
        [lxPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lxPlayer).with.offset(0);
            make.right.equalTo(lxPlayer).with.offset(0);
            make.bottom.equalTo(lxPlayer).with.offset(0);
            make.height.mas_equalTo(40);
        }];
    } completion:^(BOOL finished) {
        lxPlayer.isFullScreen = NO;
        lxPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
    }];
}
#pragma mark - 屏幕旋转通知
- (void)onDeviceOrientationChange
{
    if (lxPlayer == nil || lxPlayer.superview == nil) {
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
        case UIInterfaceOrientationPortrait:{
            if (lxPlayer.isFullScreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (lxPlayer.isFullScreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (lxPlayer.isFullScreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - releaselxplayer
- (void)releaselxPlayer
{
    [lxPlayer.player.currentItem cancelPendingSeeks];
    [lxPlayer.player.currentItem.asset cancelLoading];
    [lxPlayer.player pause];
    [lxPlayer removeFromSuperview];
    [lxPlayer.playerLayer removeFromSuperlayer];
    [lxPlayer.player replaceCurrentItemWithPlayerItem:nil];
    lxPlayer = nil;
    lxPlayer.player = nil;
    lxPlayer.currentItem = nil;
    lxPlayer.playOrPauseBtn = nil;
    lxPlayer.playerLayer = nil;
}

- (void)dealloc
{
    [self releaselxPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

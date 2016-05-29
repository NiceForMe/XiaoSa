//
//  LXRecommondViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/4/18.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXRecommondViewController.h"
#import "LXPlayer.h"
#import "View+MASAdditions.h"
@interface LXRecommondViewController ()
{
    CGRect playerFrame;
    LXPlayer *lxPlayer;
}
@end

@implementation LXRecommondViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    playerFrame = CGRectMake(0, LXNavigationBarHeight + LXStatusHeight, LXWidth, LXWidth);
    lxPlayer = [[LXPlayer alloc]initWithFrame:playerFrame videoURLStr:self.URLString];
    [self.view addSubview:lxPlayer];
    [lxPlayer play];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fullScreenBtnClick:) name:LXPlayerFullScreenButtonClickedNotification object:nil];
    }
    return self;
}
- (BOOL)prefersStatusBarHidden
{
    if (lxPlayer) {
        if (lxPlayer.isFullScreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    //屏幕旋转通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - fullScreenBtnClick
- (void)fullScreenBtnClick:(NSNotification *)notice
{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {
        lxPlayer.isFullScreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}
#pragma mark - onDeviceOrientationChange
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
                lxPlayer.isFullScreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (lxPlayer.isFullScreen == NO) {
                lxPlayer.isFullScreen = YES;
                [self setNeedsStatusBarAppearanceUpdate];
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [lxPlayer removeFromSuperview];
    lxPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        lxPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        lxPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    lxPlayer.frame = CGRectMake(0, 0, LXWidth, LXHeight);
    lxPlayer.playerLayer.frame = CGRectMake(0, 0, LXHeight, LXWidth);
    [lxPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(LXWidth - 40);
        make.width.mas_equalTo(LXHeight);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:lxPlayer];
    lxPlayer.fullScreenBtn.selected = YES;
    [lxPlayer bringSubviewToFront:lxPlayer.bottomView];
}
- (void)toNormal
{
    [lxPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        lxPlayer.transform = CGAffineTransformIdentity;
        lxPlayer.frame = CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        lxPlayer.playerLayer.frame = lxPlayer.bounds;
        [self.view addSubview:lxPlayer];
        [lxPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lxPlayer).with.offset(0);
            make.right.equalTo(lxPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(lxPlayer).with.offset(0);
        }];
    }completion:^(BOOL finished) {
        lxPlayer.isFullScreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        lxPlayer.fullScreenBtn.selected = NO;
    }];
}
#pragma mark - 
- (void)releaseLXPlayer
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
    [self releaseLXPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

//
//  LXPlayer.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/4/16.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//
/**
 *  全屏按钮被点击的通知
 */
#define LXPlayerFullScreenButtonClickedNotification @"LXPlayerFullScreenButtonClickedNotification"
/**
 *  关闭播放器的通知
 */
#define LXPlayerClosedNotification @"LXPlayerClosedNotification"
/**
 *  播放完成的通知
 */
#define LXPlayerFinishedPlayNotification @"LXPlayerFinishedPlayNotification"
/**
 *  单击播放器view的通知
 */
#define LXPlayerSingleTapNotification @"LXPlayerSingleTapNotification"
/**
 *  双击播放器view的通知
 */
#define LXPlayerDoubleTapNotification @"LXPlayerDoubleTapNotification"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LXPlayer : UIView
//播放器player
@property (nonatomic,retain) AVPlayer *player;
//playerLayer，可以修改frame
@property (nonatomic,retain) AVPlayerLayer *playerLayer;
//底部操作工具栏
@property (nonatomic,retain) UIView *bottomView;
@property (nonatomic,retain) UISlider *progressSlider;
@property (nonatomic,retain) UISlider *volumeSlider;
@property (nonatomic,copy) NSString *videoURLStr;
//亮度的进度条
@property (nonatomic,retain) UISlider *lightSlider;
//定时器
@property (nonatomic,retain) NSTimer *durationTimer;
@property (nonatomic,retain) NSTimer *autoDismissTimer;
//判断当前状态
@property (nonatomic,assign) BOOL isFullScreen;
//显示播放时间的lable
@property (nonatomic,retain) UILabel *timeLable;
//控制全屏的按钮
@property (nonatomic,retain) UIButton *fullScreenBtn;
//播放暂停
@property (nonatomic,retain) UIButton *playOrPauseBtn;
//关闭按钮
@property (nonatomic,retain) UIButton *closeBtn;
//当前播放的item
@property (nonatomic,retain) AVPlayerItem *currentItem;
//初始化
- (instancetype)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr;
- (void)play;
- (void)pause;
@end




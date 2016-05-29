//
//  LXPlayer.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/4/16.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXPlayer.h"
#import "Masonry.h"
#define LXHalfWidth self.frame.size.width * 0.5
#define LXHalfHeight self.frame.size.height * 0.5

static void *PlayViewCMTimerValue = &PlayViewCMTimerValue;
static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface LXPlayer ()<UIGestureRecognizerDelegate>
@property (nonatomic,assign) CGPoint firstPoint;
@property (nonatomic,assign) CGPoint secondPoint;
@property (nonatomic,retain) NSDateFormatter *dateFormatter;
//视频进度条的单击事件
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,assign) CGPoint originalPoint;
@end

@implementation LXPlayer
{
    UISlider *systemSlider;
}
#pragma mark - 初始化
- (AVPlayerItem *)getPlayItemWithURLString:(NSString *)urlString
{
    if ([urlString rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:urlString] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}
- (instancetype)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr
{
    self = [super init];
    if (self) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.currentItem = [self getPlayItemWithURLString:videoURLStr];
        //avplayer
        self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.layer.bounds;
        [self.layer addSublayer:_playerLayer];
        //bottomView
        self.bottomView = [[UIView alloc]init];
        [self addSubview:self.bottomView];
        //autoLayout bottomView
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self).with.offset(0);
        }];
        [self setAutoresizesSubviews:NO];
        //playOrPauseBtn
        self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
        [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        [self.bottomView addSubview:self.playOrPauseBtn];
        //autoLayout playOrPauseBtn
        [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.bottomView).with.offset(0);
            make.width.mas_equalTo(40);
        }];
        //创建亮度的进度条
        self.lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.lightSlider.hidden = YES;
        self.lightSlider.minimumValue = 0;
        self.lightSlider.maximumValue = 1;
        //进度条的值等于当前系统亮度的值
        self.lightSlider.value = [UIScreen mainScreen].brightness;
        [self.lightSlider addTarget:self action:@selector(updateLigthValue) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.lightSlider];
        MPVolumeView *volumeView = [[MPVolumeView alloc]init];
        [self addSubview:volumeView];
        volumeView.frame = CGRectMake(-1000, -100, 100, 100);
        [volumeView sizeToFit];
        systemSlider = [[UISlider alloc]init];
        systemSlider.backgroundColor = [UIColor clearColor];
        for (UIControl *view in volumeView.subviews) {
            if ([view.superclass isSubclassOfClass:[UISlider class]]) {
                systemSlider = (UISlider *)view;
            }
        }
        systemSlider.autoresizesSubviews = NO;
        systemSlider.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:systemSlider];
        
        self.volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.volumeSlider.tag = 1000;
        self.volumeSlider.hidden = YES;
        self.volumeSlider.minimumValue = systemSlider.minimumValue;
        self.volumeSlider.maximumValue = systemSlider.maximumValue;
        self.volumeSlider.value = systemSlider.value;
        [self.volumeSlider addTarget:self action:@selector(updateSystemVolumeValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.volumeSlider];
        //slider
        self.progressSlider = [[UISlider alloc]init];
        self.progressSlider.minimumValue = 0.0;
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        self.progressSlider.minimumTrackTintColor = [UIColor greenColor];
        //初始值
        self.progressSlider.value = 0.0;
        [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventTouchUpInside];
        //给进度条添加单击手势
        self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTapGesture:)];
        self.tap.delegate = self;
        [self.progressSlider addGestureRecognizer:self.tap];
        [self.bottomView addSubview:self.progressSlider];
        //autolayout
        [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView).with.offset(45);
            make.right.equalTo(self.bottomView).with.offset(-45);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.bottomView).with.offset(0);
        }];
        //fullScreen
        self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fullScreenBtn.showsTouchWhenHighlighted = YES;
        [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"nonfullscreen"] forState:UIControlStateSelected];
        [self.bottomView addSubview:self.fullScreenBtn];
        //autolayout
        [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.bottomView).with.offset(0);
            make.width.mas_equalTo(40);
        }];
        //timeLable
        self.timeLable = [[UILabel alloc]init];
        self.timeLable.textAlignment = NSTextAlignmentCenter;
        self.timeLable.textColor = [UIColor whiteColor];
        self.timeLable.font = [UIFont systemFontOfSize:11];
        [self.bottomView addSubview:self.timeLable];
        //autolayout
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView).with.offset(45);
            make.right.equalTo(self.bottomView).with.offset(-45);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.bottomView).with.offset(0);
        }];
        [self bringSubviewToFront:self.bottomView];
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        //双击
         [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        [self initTimer];
    }
    return self;
}
#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}
#pragma mark - fullScreenAction
- (void)fullScreenAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //用通知的形式把点击全屏的事件发送到app的任何地方，方便处理其他逻辑
    [[NSNotificationCenter defaultCenter]postNotificationName:LXPlayerFullScreenButtonClickedNotification object:sender];
}
#pragma mark - PlayOrPause
- (void)PlayOrPause:(UIButton *)sender
{
    if (self.durationTimer == nil) {
        self.durationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(finishedPlay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
    }
    if (self.player.rate != 1.f) {
        if ([self currentTime] == [self duration]) {
            [self setCurrentTime:0.f];
         }
        [self.player play];
        sender.selected = NO;
    }else{
        [self.player pause];
        sender.selected = YES;
    }
}
- (void)play
{
    if (self.player.rate != 1.f) {
        if ([self currentTime] == [self duration]) {
            [self setCurrentTime:0.f];
        }
        [self.player play];
    }
}
- (void)pause
{
    if (self.player.rate != 0.f) {
        [self.player pause];
    }
}
#pragma mark - 完成播放
- (void)finishedPlay:(NSTimer *)timer
{
    if ([self currentTime] == [self duration]&&self.player.rate == .0f) {
        self.playOrPauseBtn.selected = YES;
        //播放完成后的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:LXPlayerFinishedPlayNotification object:self.durationTimer];
        [self.durationTimer invalidate];
        self.durationTimer = nil;
    }
}
#pragma mark - update
- (void)updateLigthValue
{
    
}
- (void)updateSystemVolumeValue:(UISlider *)slider
{
    systemSlider.value = slider.value;
}
- (void)updateProgress:(UISlider *)slider
{
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, 1)];
}
- (void)actionTapGesture:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self.progressSlider];
    CGFloat value = (self.progressSlider.maximumValue - self.progressSlider.minimumValue) * (touchPoint.x / self.progressSlider.frame.size.width);
    [self.progressSlider setValue:value animated:YES];
    [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value, 1)];
}
#pragma mark - 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)singleTap
{
    [[NSNotificationCenter defaultCenter]postNotificationName:LXPlayerSingleTapNotification object:nil];
    [UIView animateWithDuration:0.5 animations:^{
        if (self.bottomView.alpha == 0.0) {
            self.bottomView.alpha = 1.0;
            self.closeBtn.alpha = 1.0;
        }else{
            self.bottomView.alpha = 0.0;
            self.closeBtn.alpha = 0.0;
        }
    }];
}
#pragma mark - 重写setVideoURLStr方法，处理自己的逻辑
- (void)setVideoURLStr:(NSString *)videoURLStr
{
    _videoURLStr = videoURLStr;
    if (self.currentItem) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [self.currentItem removeObserver:self forKeyPath:@"status"];
    }
    self.currentItem = [self getPlayItemWithURLString:videoURLStr];
    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
    //添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
}
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.progressSlider setValue:0.0 animated:YES];
        weakSelf.playOrPauseBtn.selected = NO;
    }];
}
#pragma mark - initTimer
- (void)initTimer
{
    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        CGFloat width = CGRectGetWidth([self.progressSlider bounds]);
        interval = 0.5f * duration / width;
    }
    __weak typeof(self) weakSelf = self;
    [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        [weakSelf syncScrubber];
    }];
    
}
- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return [playerItem duration];
    }
    return kCMTimeInvalid;
}
- (void)syncScrubber
{
    __weak typeof(self) weakSelf = self;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        weakSelf.progressSlider.minimumValue = 0.0;
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        float minValue = [weakSelf.progressSlider minimumValue];
        float maxValue = [weakSelf.progressSlider maximumValue];
        double time = CMTimeGetSeconds([weakSelf.player currentTime]);
        weakSelf.timeLable.text = [NSString stringWithFormat:@"%@/%@",[weakSelf convertTime:time],[weakSelf convertTime:duration]];
        [weakSelf.progressSlider setValue:(maxValue - minValue) * time / duration + minValue];
    }
}
- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter]setDateFormat:@"HH:mm:ss"];
    }else{
        [[self dateFormatter]setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [[self dateFormatter]stringFromDate:d];
    return newTime;
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}
- (double)duration
{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return CMTimeGetSeconds([[playerItem asset]duration]);
    }else{
        return 0.f;
    }
}
- (double)currentTime
{
    return CMTimeGetSeconds([[self player]currentTime]);
}
- (void)setCurrentTime:(double)time
{
    [[self player]seekToTime:CMTimeMakeWithSeconds(time, 1)];
}
#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == PlayViewStatusObservationContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        switch (status) {
            case AVPlayerStatusUnknown:{
                
            }
                break;
            case AVPlayerStatusReadyToPlay:{
                if (CMTimeGetSeconds(self.player.currentItem.duration)) {
                    self.progressSlider.maximumValue = CMTimeGetSeconds(self.player.currentItem.duration);
                }
                [self initTimer];
                if (self.durationTimer == nil) {
                    self.durationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(finishedPlay:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop]addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
                }
                if (self.autoDismissTimer == nil) {
                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop]addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
            }
                break;
            case AVPlayerStatusFailed:{
                
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - autoDismissBottomView
- (void)autoDismissBottomView:(UIView *)view
{
    if (self.player.rate == .0f&&[self currentTime] != [self duration]) {
        
    }else if (self.player.rate == 1.0f){
        if (self.bottomView.alpha == 1.0) {
            [UIView animateWithDuration:0.5 animations:^{
                self.bottomView.alpha = 0.0;
                self.closeBtn.alpha = 0.0;
            }];
        }
    }
}
#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in event.allTouches) {
        self.firstPoint = [touch locationInView:self];
    }
    self.volumeSlider.value = systemSlider.value;
    //记录下第一个点的位置，用于moved方法判断用户是调节音量还是调节视频
    self.originalPoint = self.firstPoint;
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in event.allTouches) {
        self.secondPoint = [touch locationInView:self];
    }
    //判断是左右滑动还是上下滑动
    CGFloat verValue = fabs(self.originalPoint.y - self.secondPoint.y);
    CGFloat horValue = fabs(self.originalPoint.x - self.secondPoint.x);
    //如果竖直方向的偏移量大于水平方向的偏移量，那么是调节音量或者亮度
    if (verValue > horValue) {//上下移动
        //判断是全屏模式还是正常模式
        if (self.isFullScreen) {
            //判断刚开始的点事左边还是右边，左边控制音量
            if (self.originalPoint.x <= LXHalfHeight) {
                systemSlider.value += (self.firstPoint.y - self.secondPoint.y) / 600.0;
                self.volumeSlider.value = systemSlider.value;
            }else{
                self.lightSlider.value += (self.firstPoint.y - self.secondPoint.y) / 600.0;
                [[UIScreen mainScreen]setBrightness:self.lightSlider.value];
            }
        }else{//非全屏
            if (self.originalPoint.x <= LXHalfWidth) {
                systemSlider.value += (self.firstPoint.y - self.secondPoint.y) / 600.0;
                self.volumeSlider.value = systemSlider.value;
            }else{
                self.lightSlider.value += (self.firstPoint.y - self.secondPoint.y) / 600.0;
                [[UIScreen mainScreen]setBrightness:self.lightSlider.value];
            }
        }
    }else{
        self.progressSlider.value -= (self.firstPoint.x - self.secondPoint.x);
        [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value, 1)];
        //滑动太快可能会停止播放
        [self.player play];
        self.playOrPauseBtn.selected = NO;
    }
    self.firstPoint = self.secondPoint;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.firstPoint = self.secondPoint = CGPointZero;
}
#pragma mark - dealloc
- (void)dealloc
{
    [self.player pause];
    self.autoDismissTimer = nil;
    self.durationTimer = nil;
    self.durationTimer = nil;
    self.player = nil;
    [self.currentItem removeObserver:self forKeyPath:@"status"];
}
@end

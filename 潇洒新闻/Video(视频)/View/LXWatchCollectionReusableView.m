//
//  LXWatchCollectionReusableView.m
//  My App
//
//  Created by niceforme on 16/1/27.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//
#define PictureCount 3
#define scrollW self.frame.size.width
#define scrollH self.frame.size.height
#define firstTag 1
#define secondTag 2
#define thirdTag 3

#import "LXWatchCollectionReusableView.h"
#import "Masonry.h"
@interface LXWatchCollectionReusableView ()
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *titleLable;
@end

@implementation LXWatchCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.frame = self.frame;
        [self addSubview:scrollView];
        //第一个
        UIImageView *firstView = [[UIImageView alloc]init];
        firstView.frame = CGRectMake(0, 0, scrollW, scrollH);
        firstView.backgroundColor = [UIColor purpleColor];
        self.firstView = firstView;
        //第二个
        UIImageView *secondView = [[UIImageView alloc]init];
        secondView.frame = CGRectMake(scrollW, 0, scrollW, scrollH);
        secondView.backgroundColor = [UIColor blackColor];
        self.secondView = secondView;
        //第三个
        UIImageView *thirdView = [[UIImageView alloc]init];
        thirdView.frame = CGRectMake(scrollW * 2, 0, scrollW, scrollH);
        thirdView.backgroundColor = [UIColor yellowColor];
        self.thirdView = thirdView;
        //将三个view添加到scrollView中去
        [scrollView addSubview:firstView];
        [scrollView addSubview:secondView];
        [scrollView addSubview:thirdView];
        //设置其他属性
        scrollView.contentSize = CGSizeMake(PictureCount * scrollW, 0);
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        self.scrollView = scrollView;
        //添加pagecontrol
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.numberOfPages = PictureCount;
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        pageControl.pageIndicatorTintColor = [UIColor greenColor];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        //设置lable
        //第一个lable
        UILabel *firstLable = [[UILabel alloc]init];
        self.firstLable = firstLable;
        [self addLable:firstLable superView:self.firstView];
        firstLable.text = @"马来西亚美女5分钟化妆挑战";
        //第二个lable
        UILabel *secondLable = [[UILabel alloc]init];
        self.secondLable = secondLable;
        [self addLable:secondLable superView:self.secondView];
        secondLable.text = @"歪果仁打造一个纯金属火柴盒";
        //第三个lable
        UILabel *thirdLable = [[UILabel alloc]init];
        self.thirdLable = thirdLable;
        [self addLable:thirdLable superView:thirdView];
        thirdLable.text = @"意大利美少女:中国人爱问我";
        //添加timer
        [self addTimer];
        //添加按钮
        //第一个btn
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake((LXWidth - 50) / 2, 80, 50, 50);
        [self addButton:firstButton superView:scrollView];
        self.firstButton = firstButton;
        //第二个btn
        UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.frame = CGRectMake((LXWidth - 50) / 2 + scrollW, 80, 50, 50);
        [self addButton:secondButton superView:scrollView];
        self.secondButton = secondButton;
        //第三个btn
        UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        thirdButton.frame = CGRectMake((LXWidth - 50) / 2 + 2 * scrollW, 80, 50, 50);
        [self addButton:thirdButton superView:scrollView];
        self.thirdButton = thirdButton;
    }
    return self;
}

#pragma mark - addImageView and lable
- (void)addLable:(UILabel *)lable superView:(UIView *)superView
{
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.frame = CGRectMake(5, 165, 260, 30);
    [superView addSubview:lable];
}
#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    //pageControl
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView).with.offset(-15);
        make.bottom.equalTo(self.scrollView).with.offset(0);
    }];
}
#pragma mark - 添加添加按钮
- (void)addButton:(UIButton *)button superView:(UIView *)view
{
    [button setImage:[UIImage imageNamed:@"video_play_btn_bg.png"] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [view addSubview:button];
}
#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width/2)/scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
#pragma mark - 添加计时器
- (void)addTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    //消息循环
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)nextImage
{
    NSInteger page = self.pageControl.currentPage;
    if (page == self.pageControl.numberOfPages - 1){
        page = 0;
    }else{
        page++;
    }
    CGFloat offset = page * self.scrollView.frame.size.width;
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    }];
}


@end

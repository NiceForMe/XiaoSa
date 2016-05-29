//
//  LXWatchCollectionViewCell.m
//  My App
//
//  Created by niceforme on 16/1/27.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//

#import "LXWatchCollectionViewCell.h"
#import "LXWatchVideoModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+SDAutoLayout.h"
@implementation LXWatchCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //图片
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = YES;
        self.imgView = imgView;
        [self addSubview:imgView];
        //文字
        UILabel *lable = [[UILabel alloc]init];
        lable.backgroundColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:13];
        self.lable = lable;
        [self addSubview:lable];
        //playerBtn
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setImage:[UIImage imageNamed:@"video_play_btn_bg.png"] forState:UIControlStateNormal];
        playBtn.showsTouchWhenHighlighted = YES;
        self.playBtn = playBtn;
        [self addSubview:playBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 30);
    self.lable.frame = CGRectMake(5, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.imgView.frame), 20);
    self.playBtn.frame = CGRectMake((self.imgView.frame.size.width - 40) / 2, (self.imgView.frame.size.height - 40) / 2  + 10, 40, 40);
}

- (void)setModel:(LXWatchVideoModel *)model
{
    self.lable.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"Default-Portrait-ns"]];
}
@end

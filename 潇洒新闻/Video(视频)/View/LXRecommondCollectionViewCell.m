//
//  LXRecommondCollectionViewCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/4/17.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXRecommondCollectionViewCell.h"
#import "LXWatchVideoModel.h"
#import <UIImageView+WebCache.h>

@implementation LXRecommondCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //图片
        self.imgView = [[UIImageView alloc]init];
        self.imgView.backgroundColor = [UIColor redColor];
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        self.imgView.layer.cornerRadius = 10;
        self.imgView.layer.masksToBounds = YES;
        [self addSubview:self.imgView];
        //文字
        self.lable = [[UILabel alloc]init];
        self.lable.backgroundColor = [UIColor grayColor];
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.textColor = [UIColor whiteColor];
        self.lable.font = [UIFont systemFontOfSize:8];
        [self addSubview:self.lable];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 30);
    self.lable.frame = CGRectMake(5, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame) - 10, 20);
}
- (void)setModel:(LXWatchVideoModel *)model
{
    self.lable.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"Default-Portrait-ns"]];
}
@end

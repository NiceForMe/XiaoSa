//
//  LXWeatherCityCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/24.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXWeatherCityCell.h"

@interface LXWeatherCityCell ()

@end

@implementation LXWeatherCityCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //lable
        UILabel *textLable = [[UILabel alloc]init];
        self.lable = textLable;
        textLable.clipsToBounds = YES;
        textLable.layer.cornerRadius = 20.0;
        textLable.backgroundColor = [UIColor lightGrayColor];
        textLable.textAlignment = NSTextAlignmentCenter;
        textLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:textLable];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lable.frame = self.contentView.frame;
}
@end

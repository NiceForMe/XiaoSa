//
//  LXHistoryCell.m
//  My App
//
//  Created by NiceForMe on 16/3/9.
//  Copyright © 2016年 NiCeForMe. All rights reserved.
//

#import "LXHistoryCell.h"
#import "LXHistoryModel.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@implementation LXHistoryCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellIdentifier";
    LXHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
#pragma mark - pravite
- (void)initUI
{
    //number
    self.numberLable = [[UILabel alloc]init];
    self.numberLable.backgroundColor = [UIColor orangeColor];
    self.numberLable.textAlignment = NSTextAlignmentCenter;
    self.numberLable.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.numberLable];
    self.numberLable.sd_layout
    .leftSpaceToView(self.contentView,5)
    .topSpaceToView(self.contentView,5)
    .widthIs(50)
    .heightIs(50);
    //标题
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.backgroundColor = [UIColor redColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLable];
    //自动布局
    self.titleLable.sd_layout
    .heightIs(50)
    .topSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,5)
    .leftSpaceToView(self.numberLable,0);
    //    内容
    self.content = [[UILabel alloc]init];
    self.content.numberOfLines = 0;
    self.content.font = [UIFont systemFontOfSize:16];
    self.content.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.content];
    //自动布局
    self.content.sd_layout
    .topSpaceToView(self.titleLable,0)
    .leftSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,5)
    //lable高度自适应
    .autoHeightRatio(0);
}
- (void)setModel:(LXHistoryModel *)model
{
    self.titleLable.text = model.title;
    self.content.text = model.event;
    [self setupAutoHeightWithBottomView:self.content bottomMargin:10];
}

@end

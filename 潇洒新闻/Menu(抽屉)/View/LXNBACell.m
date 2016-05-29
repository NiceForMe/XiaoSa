//
//  LXNBACell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/12.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNBACell.h"
#import "LXNBAModel.h"
#import "UIView+SDAutoLayout.h"
#import <UIImageView+WebCache.h>
#define Margin 5
#define CellWidth LXWidth / 3

@implementation LXNBACell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellIdentifier";
    LXNBACell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXNBACell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    //队伍、比分等等
    //第一支球队的队名以及队标
    self.player1Lable = [[UILabel alloc]init];
    self.player1Lable.textAlignment = NSTextAlignmentCenter;
    self.player1Lable.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.player1Lable];
    self.player1Lable.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,Margin)
    .widthIs(CellWidth)
    .heightIs(50);
    self.player1Image = [[UIImageView alloc]init];
    self.player1Image.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.player1Image];
    self.player1Image.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.player1Lable,0)
    .bottomSpaceToView(self.contentView,Margin)
    .widthIs(CellWidth);
    //第二支球队
    self.player2Lable = [[UILabel alloc]init];
    self.player2Lable.textAlignment = NSTextAlignmentCenter;
    self.player2Lable.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.player2Lable];
    self.player2Lable.sd_layout
    .topSpaceToView(self.contentView,Margin)
    .rightSpaceToView(self.contentView,0)
    .widthIs(CellWidth)
    .heightIs(50);
    self.player2Image = [[UIImageView alloc]init];
    self.player2Image.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.player2Image];
    self.player2Image.sd_layout
    .topSpaceToView(self.player2Lable,0)
    .rightSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,Margin)
    .widthIs(CellWidth);
    //比赛时间
    self.timeLable = [[UILabel alloc]init];
    self.timeLable.font = [UIFont systemFontOfSize:15];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    self.timeLable.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.timeLable];
    self.timeLable.sd_layout
    .topSpaceToView(self.contentView,Margin)
    .leftSpaceToView(self.player1Lable,0)
    .rightSpaceToView(self.player2Lable,0)
    .heightIs(60);
    //比分
    self.scoreLable = [[UILabel alloc]init];
    self.scoreLable.textAlignment = NSTextAlignmentCenter;
    self.scoreLable.backgroundColor = [UIColor whiteColor];
    self.scoreLable.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.scoreLable];
    self.scoreLable.sd_layout
    .topSpaceToView(self.timeLable,0)
    .leftSpaceToView(self.player1Lable,0)
    .bottomSpaceToView(self.contentView,Margin)
    .rightSpaceToView(self.player2Lable,0);
}

- (void)setModel:(LXNBAModel *)model
{
    self.player1Lable.text = model.player1;
    [self.player1Image sd_setImageWithURL:[NSURL URLWithString:model.player1logo]];
    self.player2Lable.text = model.player2;
    [self.player2Image sd_setImageWithURL:[NSURL URLWithString:model.player2logo]];
    self.timeLable.text = model.time;
    self.scoreLable.text = model.score;
}

@end

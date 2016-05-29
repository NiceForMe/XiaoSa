//
//  LXSettingCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/25.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXSettingCell.h"
#import <UIView+SDAutoLayout.h>
@implementation LXSettingCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    LXSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        UILabel *titleLable = [[UILabel alloc]init];
        self.titleLable = titleLable;
        titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLable];
        //副标题
        UILabel *subtitleLable = [[UILabel alloc]init];
        subtitleLable.textAlignment = NSTextAlignmentRight;
        self.subtitleLable = subtitleLable;
        [self.contentView addSubview:subtitleLable];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLable.sd_layout
    .leftSpaceToView(self.contentView,10)
    .widthIs(100)
    .heightIs(self.contentView.frame.size.height);
    self.subtitleLable.sd_layout
    .rightSpaceToView(self.contentView,10)
    .widthIs(100)
    .heightIs(self.contentView.frame.size.height);
}
@end

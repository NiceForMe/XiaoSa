//
//  LXNewsNoPictureCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNewsNoPictureCell.h"

@interface LXNewsNoPictureCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UIView *seperatorLine;

@end

@implementation LXNewsNoPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLable.text = titleText;
}
- (void)setContentText:(NSString *)contentText
{
    _contentText = contentText;
    self.desLable.text = contentText;
}

@end

//
//  LXNewsSinglePictureCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNewsSinglePictureCell.h"
#import <UIImageView+WebCache.h>
@interface LXNewsSinglePictureCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UIView *seperatorLine;

@end

@implementation LXNewsSinglePictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  LXNewsMultiPictureCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNewsMultiPictureCell.h"
#import <UIImageView+WebCache.h>
@interface LXNewsMultiPictureCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIView *seperatorLine;

@end

@implementation LXNewsMultiPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    [self.imgView1 sd_setImageWithURL:imageUrls[0][@"url"] placeholderImage:nil];
    [self.imgView2 sd_setImageWithURL:imageUrls[1][@"url"] placeholderImage:nil];
    [self.imgView3 sd_setImageWithURL:imageUrls[2][@"url"] placeholderImage:nil];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLable.text = titleText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

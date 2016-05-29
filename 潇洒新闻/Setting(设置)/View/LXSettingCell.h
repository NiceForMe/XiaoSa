//
//  LXSettingCell.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/25.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXSettingCell : UITableViewCell

@property (nonatomic,weak) UILabel *titleLable;
@property (nonatomic,weak) UILabel *subtitleLable;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

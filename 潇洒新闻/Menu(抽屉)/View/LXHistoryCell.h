//
//  LXHistoryCell.h
//  My App
//
//  Created by NiceForMe on 16/3/9.
//  Copyright © 2016年 NiCeForMe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXHistoryModel;
@interface LXHistoryCell : UITableViewCell
@property (nonatomic,strong) LXHistoryModel *model;
@property (nonatomic,strong) UILabel *numberLable;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *content;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

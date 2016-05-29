//
//  LXNBACell.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/12.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LXNBAModel;
@interface LXNBACell : UITableViewCell
@property (nonatomic,strong) LXNBAModel *model;
@property (nonatomic,strong) UILabel *player1Lable;
@property (nonatomic,strong) UILabel *player2Lable;
@property (nonatomic,strong) UIImageView *player1Image;
@property (nonatomic,strong) UIImageView *player2Image;
@property (nonatomic,strong) UILabel *timeLable;
@property (nonatomic,strong) UILabel *scoreLable;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

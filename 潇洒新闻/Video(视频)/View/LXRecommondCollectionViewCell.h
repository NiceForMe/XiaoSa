//
//  LXRecommondCollectionViewCell.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/4/17.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXWatchVideoModel;
@interface LXRecommondCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lable;

@property (nonatomic,retain) LXWatchVideoModel *model;

@end

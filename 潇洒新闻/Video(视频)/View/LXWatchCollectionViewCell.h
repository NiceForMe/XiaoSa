//
//  LXWatchCollectionViewCell.h
//  My App
//
//  Created by niceforme on 16/1/27.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXVideoModel;
@interface LXWatchCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lable;
@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,retain) LXVideoModel *model;
@end

//
//  LXWatchCollectionReusableView.h
//  My App
//
//  Created by niceforme on 16/1/27.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXWatchVideoModel;

@interface LXWatchCollectionReusableView : UICollectionReusableView<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *firstView;
@property (nonatomic,strong) UIImageView *secondView;
@property (nonatomic,strong) UIImageView *thirdView;

@property (nonatomic,strong) UILabel *firstLable;
@property (nonatomic,strong) UILabel *secondLable;
@property (nonatomic,strong) UILabel *thirdLable;

@property (nonatomic,strong) UIButton *firstButton;
@property (nonatomic,strong) UIButton *secondButton;
@property (nonatomic,strong) UIButton *thirdButton;


@end

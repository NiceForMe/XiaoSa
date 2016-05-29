//
//  LXBaseViewController.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/11.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface LXBaseViewController : UIViewController
@property (nonatomic,retain) MBProgressHUD *hud;
- (void)addHud;
- (void)addHudToView:(UIView *)view;
- (void)showError;
- (void)removeHud;

@end

//
//  LXBaseViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/11.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXBaseViewController.h"
#import <MBProgressHUD.h>
@interface LXBaseViewController ()

@end

@implementation LXBaseViewController

- (void)addHud
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载...";
        _hud.detailsLabelText = @"请稍等";
        _hud.detailsLabelFont = [UIFont systemFontOfSize:17];
    }
}
- (void)addHudToView:(UIView *)view
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        _hud.labelText = @"正在加载...";
    }
}
- (void)showError
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"网络异常,加载失败";
        _hud.detailsLabelText = @"请稍后再试";
        _hud.detailsLabelFont = [UIFont systemFontOfSize:17];
        [_hud hide:YES afterDelay:3.5];
    }
}
- (void)removeHud
{
    if (_hud) {
        [_hud removeFromSuperview];
        _hud = nil;
    }
}

@end

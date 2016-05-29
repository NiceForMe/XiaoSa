//
//  LXNavigationController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/11.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNavigationController.h"

@interface LXNavigationController ()

@end

@implementation LXNavigationController
+ (void)initialize
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置普通状态
    NSMutableDictionary *text = [NSMutableDictionary dictionary];
    text[NSForegroundColorAttributeName] = [UIColor orangeColor];
    text[NSFontAttributeName] = [UIFont systemFontOfSize:19];
    [item setTitleTextAttributes:text forState:UIControlStateNormal];
    //设置不可点击状态
    NSMutableDictionary *disableText = [NSMutableDictionary dictionary];
    disableText[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    disableText[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disableText forState:UIControlStateDisabled];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

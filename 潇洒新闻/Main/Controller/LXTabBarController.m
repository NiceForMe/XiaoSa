//
//  LXTabBarController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/11.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXTabBarController.h"
#import "LXNavigationController.h"
#import "LXNewsMainViewController.h"
#import "LXWatchViewController.h"
#import "LXSettingController.h"
@interface LXTabBarController ()

@end

@implementation LXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    LXNewsMainViewController *news = [[LXNewsMainViewController alloc]init];
    [self addChildViewController:news title:@"看新闻" image:@"news" selectedImage:nil];
    LXWatchViewController *watch = [[LXWatchViewController alloc]init];
    [self addChildViewController:watch title:@"看视频" image:@"video" selectedImage:nil];
    LXSettingController *set = [[LXSettingController alloc]init];
    [self addChildViewController:set title:@"设置" image:@"profile" selectedImage:nil];
}
#pragma mark - private
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置控制器的标题
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    [childController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    LXNavigationController *nav = [[LXNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:nav];
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

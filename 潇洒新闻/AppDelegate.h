//
//  AppDelegate.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/11.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RESideMenu;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy) NSArray *sidArray;
@property (nonatomic,copy) NSArray *videoArray;

+ (AppDelegate *)shareAppDelegate;

@end


//
//  LXJudgeNetworking.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,NetWorkingType){
    NetworkingTypeNoReachable = 1,
    NetworkingType3G = 2,
    NetworkingTypeWiFi = 3,
};

@interface LXJudgeNetworking : NSObject
+ (BOOL)judge;
+ (NetWorkingType)currentNetWorkingType;
@end

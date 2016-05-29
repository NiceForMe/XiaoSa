//
//  LXJudgeNetworking.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXJudgeNetworking.h"
#import <Reachability.h>
@implementation LXJudgeNetworking
+ (BOOL)judge
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}
+ (NetWorkingType)currentNetWorkingType
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == ReachableViaWiFi) {
        return NetworkingTypeWiFi;
    }else if ([reachability currentReachabilityStatus] == ReachableViaWWAN){
        return NetworkingType3G;
    }
    return NetworkingTypeNoReachable;
}
@end

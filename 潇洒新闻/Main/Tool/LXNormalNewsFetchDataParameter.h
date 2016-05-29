//
//  LXNormalNewsFetchDataParameter.h
//  LXNews
//
//  Created by NiceForMe on 16/5/2.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXNormalNewsFetchDataParameter : NSObject
@property (nonatomic, assign) NSInteger recentTime;//最新的picture的时间
@property (nonatomic, assign) NSInteger remoteTime;//最晚的picture的时间

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger page;

@end

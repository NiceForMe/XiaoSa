//
//  LXWeatherModel.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/24.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXWeatherModel : NSObject
//天气
@property (nonatomic,copy) NSString *weather;
//气温
@property (nonatomic,copy) NSString *temp;
//最高气温
@property (nonatomic,copy) NSString *l_tmp;
//最低气温
@property (nonatomic,copy) NSString *h_tmp;
//城市
@property (nonatomic,copy) NSString *city;
//date
@property (nonatomic,copy) NSString *date;
//time
@property (nonatomic,copy) NSString *time;
//经度
@property (nonatomic,copy) NSString *longitude;
//维度
@property (nonatomic,copy) NSString *latitude;
//海拔
@property (nonatomic,copy) NSString *altitude;
//风向
@property (nonatomic,copy) NSString *WD;
//风力
@property (nonatomic,copy) NSString *WS;
//日出时间
@property (nonatomic,copy) NSString *sunrise;
//日落时间
@property (nonatomic,copy) NSString *sunset;

@end

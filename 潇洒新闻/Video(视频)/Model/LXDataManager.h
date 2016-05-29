//
//  LXDataManager.h
//  My App
//
//  Created by niceforme on 16/2/13.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXWeatherModel;
@interface LXDataManager : NSObject

@property (nonatomic,copy) NSArray *sidArray;
@property (nonatomic,copy) NSArray *videoArray;
@property (nonatomic,copy) NSArray *nbaArray;
+ (LXDataManager *)shareManager;

- (void)getSidArrayWithURLString:(NSString *)URLString success:(void(^)(NSArray *sidArray,NSArray * videoArray))success failed:(void(^)(NSError *error))failed;
- (void)getVideoArrayWithURLString:(NSString *)URLString ListID:(NSString *)ID success:(void(^)(NSArray *listArray))success failed:(void(^)(NSError *error))failed;
//nba
- (void)getNBAArrayWithURLString:(NSString *)URLString success:(void(^)(NSArray *nbaArray))success failed:(void(^)(NSError *error))failed;
//history
- (void)getHistoryArrayWithURLString:(NSString *)URLString success:(void(^)(NSArray *historyArray))success failed:(void(^)(NSError *error))failed;
//weather
- (void)getWeatherDataWithCityName:(NSString *)name suceess:(void(^)(LXWeatherModel *model))success;
@end

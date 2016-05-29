//
//  LXDataManager.m
//  My App
//
//  Created by niceforme on 16/2/13.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//
#import "LXDataManager.h"
#import "LXWatchVideoModel.h"
#import "LXWatchSidModel.h"
#import "LXNBAModel.h"
#import "LXHistoryModel.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "LXWeatherModel.h"

@implementation LXDataManager
+ (LXDataManager *)shareManager
{
    static LXDataManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class]alloc]init];
    });
    return manager;
}


- (void)getSidArrayWithURLString:(NSString *)URLString success:(void (^)(NSArray *, NSArray *))success failed:(void (^)(NSError *))failed
{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableArray *videoArray = [NSMutableArray array];
        NSMutableArray *sidArray = [NSMutableArray array];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *video in dict[@"videoList"]) {
                    LXWatchVideoModel *model = [[LXWatchVideoModel alloc]init];
                    [model setValuesForKeysWithDictionary:video];
                    [videoArray addObject:model];
                }
                self.videoArray = [NSArray arrayWithArray:videoArray];
                for (NSDictionary *d in dict[@"videoSidList"]) {
                    LXWatchSidModel *model = [[LXWatchSidModel alloc]init];
                    [model setValuesForKeysWithDictionary:d];
                    [sidArray addObject:model];
                }
                self.sidArray = [NSArray arrayWithArray:sidArray];
                success(sidArray,videoArray);
            }
        }];
        [task resume];
    });
}
- (void)getVideoArrayWithURLString:(NSString *)URLString ListID:(NSString *)ID success:(void(^)(NSArray *listArray))success failed:(void(^)(NSError *error))failed
{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableArray *listArrray = [NSMutableArray array];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSArray *videoList = [dict objectForKey:ID];
                for (NSDictionary *video in videoList) {
                    LXWatchVideoModel *model = [[LXWatchVideoModel alloc]init];
                    [model setValuesForKeysWithDictionary:video];
                    [listArrray addObject:model];
                }
                success(listArrray);
            }
        }];
        [task resume];
    });
}
//nba
- (void)getNBAArrayWithURLString:(NSString *)URLString success:(void (^)(NSArray *))success failed:(void (^)(NSError *))failed
{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSMutableArray *array = [NSMutableArray array];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict1 = [responseObject valueForKey:@"result"];
            NSArray *dicArray = dict1[@"list"];
            NSDictionary *nbaDic = [dicArray objectAtIndex:1];
            NSArray *nbaArray = nbaDic[@"tr"];
            for (NSDictionary *d in nbaArray) {
                LXNBAModel *model = [LXNBAModel mj_objectWithKeyValues:d];
                [array addObject:model];
            }
            success(array);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            failed(error);
        }];
    });
}
//history
- (void)getHistoryArrayWithURLString:(NSString *)URLString success:(void (^)(NSArray *))success failed:(void (^)(NSError *))failed
{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        NSMutableArray *array = [NSMutableArray array];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *dicArray = responseObject[@"result"];
            for (NSDictionary *dict in dicArray) {
                LXHistoryModel *model = [LXHistoryModel mj_objectWithKeyValues:dict];
                [array addObject:model];
            }
            success(array);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failed(error);
        }];
    });
}
//weather
- (void)getWeatherDataWithCityName:(NSString *)name suceess:(void (^)(LXWeatherModel *))success
{
    dispatch_queue_t global_t = dispatch_get_global_queue(0, 0);
    dispatch_async(global_t, ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *str = @"http://apis.baidu.com/apistore/weatherservice/cityname?cityname=";
        NSString *urlStr = [str stringByAppendingString:name];
        [manager.requestSerializer setValue:@"093b458afaea17211d2eb6be9871e60c" forHTTPHeaderField:@"apikey"];
        [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = responseObject[@"retData"];
            LXWeatherModel *model = [LXWeatherModel mj_objectWithKeyValues:dict];
            success(model);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    });
}
@end

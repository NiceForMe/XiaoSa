//
//  LXDataTool.m
//  LXNews
//
//  Created by NiceForMe on 16/5/2.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXDataTool.h"
#import "LXJudgeNetworking.h"
#import "LXNormalNewsFetchDataParameter.h"
#import <AFNetworking.h>
#import "LXNormalNews.h"
#import <MJExtension.h>
#import <FMDB.h>

static NSString * const apikey = @"093b458afaea17211d2eb6be9871e60c";

@implementation LXDataTool
static FMDatabaseQueue *_queue;

+(void)initialize {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists table_ttheadernews(id integer primary key autoincrement, title text, url text, abstract text, image_url text);"];
        
        [db executeUpdate:@"create table if not exists table_normalnews(id integer primary key autoincrement, channelid text, title text, imageurls blob, desc text, link text, pubdate text, createdtime integer, source text);"];
    }];
}


+ (void)LXNormalNewsWithParameters:(LXNormalNewsFetchDataParameter *)normalNewsParameters success:(void(^)(NSMutableArray *array))success failure:(void(^)(NSError *error))failure {
    if (![LXJudgeNetworking judge]) {
        LXNormalNewsFetchDataParameter *tempParameters = [[LXNormalNewsFetchDataParameter alloc] init];
        tempParameters.channelId = normalNewsParameters.channelId;
        NSMutableArray *tempCacheArray = [self selectDataFromTTNormalNewsCacheWithParameters:tempParameters];
        success(tempCacheArray);
        return;
    }
    NSMutableArray *cacheArray = [self selectDataFromTTNormalNewsCacheWithParameters:normalNewsParameters];
    
    if (cacheArray.count == 20) {
        success(cacheArray);
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"channelid"] = normalNewsParameters.channelId;
        parameters[@"channelName"] = [normalNewsParameters.channelName stringByAppendingString:@"最新"];
        parameters[@"title"] = normalNewsParameters.title;
        parameters[@"page"] = @(normalNewsParameters.page);
        [manager GET:@"http://apis.baidu.com/showapi_open_bus/channel_news/search_news" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *pictureArray = [LXNormalNews mj_objectArrayWithKeyValuesArray:responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"]];
            for (LXNormalNews *news in pictureArray) {
                news.allPages = [responseObject[@"showapi_res_body"][@"pagebean"][@"allPages"] integerValue];
            }
            [self addLXNormalNewsArray:pictureArray];
            success(pictureArray);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
    
}
+(void)addLXNormalNewsArray:(NSMutableArray *)newsArray {
    for (LXNormalNews *news in newsArray) {
        [self addLXNormalNews:news];
    }
}
+(void)addLXNormalNews:(LXNormalNews *)news {
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_normalnews WHERE link = '%@';",news.link];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            NSData *imageurls = [NSKeyedArchiver archivedDataWithRootObject:news.imageurls];
            [db executeUpdate:@"insert into table_normalnews (title , pubdate, createdtime, source, desc, link, imageurls, channelid) values(?,?,?,?,?,?,?,?);",news.title, news.pubDate, @(news.createdtime), news.source, news.desc, news.link, imageurls,news.channelId];
        }
        [result close];
    }];
}

+(NSMutableArray *)selectDataFromTTNormalNewsCacheWithParameters:(LXNormalNewsFetchDataParameter *)parameters {
    __block NSMutableArray *newsArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        newsArray = [NSMutableArray array];
        FMResultSet *result = nil;
        if (parameters.recentTime!=0) {//时间更大，代表消息发布越靠后，因为时间是按real来储存的
            NSInteger time = parameters.recentTime;
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where createdtime > %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];
            
            result = [db executeQuery:sql];
            
        }
        
        if(parameters.remoteTime!=0) {
            NSInteger time = parameters.remoteTime;
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where createdtime < %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];
            
            result = [db executeQuery:sql];
        }
        
        if (parameters.remoteTime==0 && parameters.recentTime==0){
            
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where channelid = '%@' order by createdtime desc limit 0,20;", parameters.channelId];
            result = [db executeQuery:sql];
        }
        
        while (result.next) {
            LXNormalNews *news = [[LXNormalNews alloc] init];
            news.title = [result stringForColumn:@"title"];
            news.pubDate = [result stringForColumn:@"pubdate"];
            news.createdtime  = [result longLongIntForColumn:@"createdtime"];
            
            news.imageurls = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"imageurls"]];
            news.source = [result stringForColumn:@"source"];
            news.desc = [result stringForColumn:@"desc"];
            news.link = [result stringForColumn:@"link"];
            news.channelId = [result stringForColumn:@"channelId"];
            [newsArray addObject:news];
        }
    }];
    return newsArray;
}


@end

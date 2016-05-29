//
//  LXNBAModel.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/3/16.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXNBAModel : NSObject
//日期
@property (nonatomic,strong) NSString *title;
//技术统计url
@property (nonatomic,strong) NSString *link2url;
@property (nonatomic,strong) NSString *player1;
@property (nonatomic,strong) NSString *player2;
@property (nonatomic,strong) NSString *player1logo;
@property (nonatomic,strong) NSString *player1logobig;
@property (nonatomic,strong) NSString *player2logo;
@property (nonatomic,strong) NSString *player2logobig;
@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *time;


@end

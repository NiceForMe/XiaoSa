//
//  LXNormalNews.h
//  LXNews
//
//  Created by NiceForMe on 16/4/23.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,NormalNewsType){
    NormalNewsTypeNoPicture = 1,
    NormalNewsTypeSigalPicture = 2,
    NormalNewsTypeMultiPicture = 3,//图片大于等于三张
};

@interface LXNormalNews : NSObject

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *desc;//简介
@property (nonatomic, strong) NSArray *imageurls;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *pubDate;//发布日期
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger allPages;

//自己定义的变量
@property (nonatomic, assign) NormalNewsType normalNewsType;
@property (nonatomic, assign) NSInteger createdtime;//发布日期
@property (nonatomic, assign) CGFloat cellHeight;



@end

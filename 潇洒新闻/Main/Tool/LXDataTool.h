//
//  LXDataTool.h
//  LXNews
//
//  Created by NiceForMe on 16/5/2.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LXNormalNewsFetchDataParameter;
@interface LXDataTool : NSObject

+ (void)LXNormalNewsWithParameters:(LXNormalNewsFetchDataParameter *)normalNewsParameters success:(void(^)(NSMutableArray *array))success failure:(void(^)(NSError *error))failure;

@end

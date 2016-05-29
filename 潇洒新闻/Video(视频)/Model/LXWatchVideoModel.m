//
//  LXWatchVideoModel.m
//  My App
//
//  Created by niceforme on 16/2/13.
//  Copyright (c) 2016年 NiCeForMe. All rights reserved.
//

#import "LXWatchVideoModel.h"

@implementation LXWatchVideoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionDe = value;
    }
}
@end

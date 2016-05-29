//
//  LXNewsSinglePictureCell.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXNewsSinglePictureCell : UITableViewCell

@property (nonatomic, strong) NSArray *pictureArray;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *contentText;

@end

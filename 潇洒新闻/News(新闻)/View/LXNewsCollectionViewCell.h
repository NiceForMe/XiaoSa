//
//  LXNewsCollectionViewCell.h
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelCollectionViewCellDelegate <NSObject>

- (void)deleteTheCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LXNewsCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString *channelName;
@property (nonatomic,strong) NSIndexPath *theIndexPath;
@property (nonatomic,weak) id delegate;

@end

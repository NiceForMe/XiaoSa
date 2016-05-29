//
//  LXNewsCollectionViewCell.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/8.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNewsCollectionViewCell.h"

@interface LXNewsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation LXNewsCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteButton.hidden = YES;
}
- (IBAction)DeleteTheChannel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteTheCellAtIndexPath:)]) {
        [self.delegate deleteTheCellAtIndexPath:self.theIndexPath];
    }
    self.deleteButton.hidden = YES;
}
- (void)setTheIndexPath:(NSIndexPath *)theIndexPath
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(wantToDeleteTheChannel)];
    recognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:recognizer];
    _theIndexPath = theIndexPath;
}
- (void)wantToDeleteTheChannel
{
    self.deleteButton.hidden = NO;
}
- (void)setChannelName:(NSString *)channelName
{
    _channelName = channelName;
    self.channelNameLabel.text = channelName;
}

@end

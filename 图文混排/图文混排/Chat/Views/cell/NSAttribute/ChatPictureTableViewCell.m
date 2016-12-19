//
//  ChatPictureTableViewCell.m
//  图文混排
//
//  Created by yanzhen on 16/11/21.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatPictureTableViewCell.h"
#import "ChatPictureFrame.h"
#import "OLImageView.h"

@interface ChatPictureTableViewCell ()
@property (strong, nonatomic) OLImageView *pictureIV;
@end

@implementation ChatPictureTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        OLImageView *pictureIV = [[OLImageView alloc] init];
//        //拖动tableView--gif动画不受影响
//        pictureIV.runLoopMode = NSRunLoopCommonModes;
        pictureIV.layer.masksToBounds = YES;
        pictureIV.layer.cornerRadius = 5.0;
        [self.bubbleImageView addSubview:pictureIV];
        _pictureIV = pictureIV;
    }
    return self;
}

-(void)setPictureFrame:(ChatPictureFrame *)pictureFrame{
    _pictureFrame = pictureFrame;
    _pictureIV.image = pictureFrame.pictureModel.image;
    self.headImageView.frame = pictureFrame.headIVFrame;
    _pictureIV.frame = pictureFrame.imageViewFrame;
    
    UIImage *image = [UIImage imageNamed:pictureFrame.pictureModel.send ? @"sendMessageSelf" : @"receiveMessage"];
    self.bubbleImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 28, 10, 28) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView.frame = pictureFrame.bubbleIVFrame;
}

@end

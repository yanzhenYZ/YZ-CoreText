//
//  YZWeChatPictureTableViewCell.m
//  图文混排
//
//  Created by yanzhen on 16/12/19.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "YZWeChatPictureTableViewCell.h"
#import "ChatPictureFrame.h"

@interface YZWeChatPictureTableViewCell ()
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//气泡
@property (nonatomic, strong) UIImageView *bubbleImageView;

@property (nonatomic, strong) UIImageView *layerImageView;
@end

@implementation YZWeChatPictureTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.image = [UIImage imageNamed:@"HeadImage"];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = HEADVIEWWH / 2;
        [self.contentView addSubview:self.headImageView];
        
        self.bubbleImageView = [[UIImageView alloc] init];
        self.bubbleImageView.userInteractionEnabled = YES;
        //添加很多子视图
        self.bubbleImageView.clipsToBounds = YES;
        [self addSubview:self.bubbleImageView];
        
        _layerImageView = [[UIImageView alloc] init];
        
    }
    return self;
}

-(void)setPictureFrame:(ChatPictureFrame *)pictureFrame{
    _pictureFrame = pictureFrame;
    self.headImageView.frame = pictureFrame.headIVFrame;
    
    _bubbleImageView.image = pictureFrame.pictureModel.image;
    self.bubbleImageView.frame = pictureFrame.bubbleIVFrame;
    self.layerImageView.frame = pictureFrame.bubbleIVFrame;
    
    
    UIImage *image = [UIImage imageNamed:pictureFrame.pictureModel.send ? @"sendMessageSelf" : @"receiveMessage"];
    self.layerImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 28, 10, 28) resizingMode:UIImageResizingModeStretch];
    CALayer *layer = self.layerImageView.layer;
    layer.frame	   = (CGRect){{0,0},self.layerImageView.layer.frame.size};
    self.bubbleImageView.layer.mask = layer;
    
}
@end

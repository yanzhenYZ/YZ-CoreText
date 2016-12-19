//
//  ChatPictureFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatPictureFrame.h"

@implementation ChatPictureFrame

-(ChatModel *)chatModel{
    return _pictureModel;
}

-(void)setPictureModel:(ChatPictureModel *)pictureModel{
    _pictureModel = pictureModel;
    if (pictureModel.image) {
        CGSize size = pictureModel.image.size;
        if (size.height > 0) {
            CGFloat headSpace = HEADIMAGESPACE * 2 + HEADVIEWWH;
            CGFloat maxImageWidth = WIDTH / 2 - headSpace                                                                                                                                                                                                                                                                                                                                              ;
            if (size.width > maxImageWidth) {
                size.height = maxImageWidth / size.width * size.height;
                size.width = maxImageWidth;
            }
            
            CGFloat imageX = self.pictureModel.send ? 0 : CHATIMAGESPACE;
#pragma mark - to do
            CGFloat space = 0.5;
            _imageViewFrame = CGRectMake(imageX + space, space, size.width - 2 * space, size.height - 2 * space);
            
            
            imageX = self.pictureModel.send ? WIDTH - headSpace - size.width : headSpace;
            self.bubbleIVFrame = CGRectMake(imageX, HEADIMAGESPACE, size.width + CHATIMAGESPACE, size.height);
            self.rowHeight = CGRectGetMaxY(self.bubbleIVFrame) + HEADIMAGESPACE;
        }
    }
}

@end

#pragma mark - ChatPictureModel
@implementation ChatPictureModel : ChatModel
-(ChatMessageType)messageType{
    return ChatMessageTypePicture;
}

-(void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    if (!self.image) {
        NSString *path = [DOCUMENT stringByAppendingPathComponent:imagePath];
        self.image = [UIImage imageWithContentsOfFile:path];
    }
}

-(void)setShowTimeLabel:(BOOL)showTimeLabel{
    [super setShowTimeLabel:showTimeLabel];
    if (showTimeLabel) {
        
    }
}
@end

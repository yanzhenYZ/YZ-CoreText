//
//  ChatPictureFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

@class ChatPictureModel;
@interface ChatPictureFrame : ChatFrame

@property (nonatomic, strong) ChatPictureModel *pictureModel;
@property (nonatomic, assign, readonly) CGRect imageViewFrame;
@end

#pragma mark - ChatPictureModel
@interface ChatPictureModel : ChatModel
//gif---OLImage
@property (nonatomic, strong) UIImage *image;
//路径不包含NSHomeDirectory()
@property (nonatomic, copy) NSString *imagePath;
@end

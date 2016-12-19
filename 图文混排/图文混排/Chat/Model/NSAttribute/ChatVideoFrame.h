//
//  ChatVideoFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

@class ChatVideoModel;
@interface ChatVideoFrame : ChatFrame

@property (nonatomic, strong) ChatVideoModel *videoModel;

@end

#pragma mark - ChatVideoModel
@interface ChatVideoModel : ChatModel

@end

//
//  ChatAudioFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

@class ChatAudioModel;
@interface ChatAudioFrame : ChatFrame

@property (nonatomic, strong) ChatAudioModel *audioModel;

@end

#pragma mark - ChatAudioModel
@interface ChatAudioModel : ChatModel

@end

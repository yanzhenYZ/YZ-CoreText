//
//  ChatVideoFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatVideoFrame.h"

@implementation ChatVideoFrame

-(ChatModel *)chatModel{
    return _videoModel;
}

-(void)setVideoModel:(ChatVideoModel *)videoModel{
    _videoModel= videoModel;
}

@end

#pragma mark - ChatVideoModel
@implementation ChatVideoModel : ChatModel

-(ChatMessageType)messageType{
    return ChatMessageTypeVideo;
}

-(void)setShowTimeLabel:(BOOL)showTimeLabel{
    [super setShowTimeLabel:showTimeLabel];
    if (showTimeLabel) {
        
    }
}
@end

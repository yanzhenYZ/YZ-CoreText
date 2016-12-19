//
//  ChatAudioFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatAudioFrame.h"

@implementation ChatAudioFrame

-(ChatModel *)chatModel{
    return _audioModel;
}

-(void)setAudioModel:(ChatAudioModel *)audioModel{
    _audioModel = audioModel;
}

@end

#pragma mark - ChatAudioModel
@implementation ChatAudioModel : ChatModel

-(ChatMessageType)messageType{
    return ChatMessageTypeAudio;
}

-(void)setShowTimeLabel:(BOOL)showTimeLabel{
    [super setShowTimeLabel:showTimeLabel];
    if (showTimeLabel) {
        
    }
}
@end

//
//  ChatFileFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFileFrame.h"

@implementation ChatFileFrame

-(ChatModel *)chatModel{
    return _fileModel;
}

-(void)setFileModel:(ChatFileModel *)fileModel{
    _fileModel = fileModel;
}


@end

#pragma mark - ChatFileModel
@implementation ChatFileModel : ChatModel

-(ChatMessageType)messageType{
    return ChatMessageTypeFile;
}

-(void)setShowTimeLabel:(BOOL)showTimeLabel{
    [super setShowTimeLabel:showTimeLabel];
    if (showTimeLabel) {
        
    }
}
@end

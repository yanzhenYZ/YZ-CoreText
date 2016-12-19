//
//  ChatFileFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

@class ChatFileModel;
@interface ChatFileFrame : ChatFrame

@property (nonatomic, strong) ChatFileModel *fileModel;

@end

#pragma mark - ChatFileModel
@interface ChatFileModel : ChatModel



@end

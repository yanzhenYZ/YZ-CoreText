//
//  ChatCoreTextTableViewCell.h
//  图文混排
//
//  Created by yanzhen on 16/11/24.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatTableViewCell.h"

@class CoreTextModel;
@class ChatCoreTextFrame;
@protocol ChatCoreTextTableViewCellDelegate <NSObject>

- (void)didSelectedSpecial:(CoreTextModel *)textModel;

@end

@interface ChatCoreTextTableViewCell : ChatTableViewCell

@property (nonatomic, strong) ChatCoreTextFrame *textFrame;
@property (nonatomic, weak) id<ChatCoreTextTableViewCellDelegate>delegate;

@end

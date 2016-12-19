//
//  ChatTextTableViewCell.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatTableViewCell.h"

@class ChatTextFrame;
@class CoreTextModel;
@protocol ChatTableViewCellDelegate <NSObject>

@optional
- (void)didSelectedSpecial:(CoreTextModel *)textModel;

@end


@interface ChatTextTableViewCell : ChatTableViewCell

@property (nonatomic, strong) ChatTextFrame *textFrame;
@property (nonatomic, weak) id<ChatTableViewCellDelegate> delegate;

@end

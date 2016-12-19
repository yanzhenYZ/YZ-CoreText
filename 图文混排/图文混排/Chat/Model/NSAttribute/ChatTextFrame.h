//
//  ChatTextFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

@class ChatTextModel;
@interface ChatTextFrame : ChatFrame

@property (nonatomic, strong) ChatTextModel *textModel;
@property (nonatomic, assign, readonly) CGRect textViewFrame;

@end

#pragma mark - ChatTextModel
@interface ChatTextModel : ChatModel
/**          文字内容                 */
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, readonly) NSAttributedString *attributedString;
@property (nonatomic, assign) CGSize textSize;

@end

//
//  ChatCoreTextFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/24.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

//字体大小
#define CoreTextFont [UIFont systemFontOfSize:17]
//字间距
#define CoreTextLineSpace 4.0
//字体颜色
#define CoreTextColor [UIColor blackColor]

@class ChatCoreTextModel;
@interface ChatCoreTextFrame : ChatFrame
@property (nonatomic, strong) ChatCoreTextModel *textModel;
@property (nonatomic, assign, readonly) CGRect textViewFrame;
@end

#pragma mark - ChatCoreTextModel
@interface ChatCoreTextModel : ChatModel
/**          文字内容                 */
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, readonly) NSAttributedString *attributedString;
@end

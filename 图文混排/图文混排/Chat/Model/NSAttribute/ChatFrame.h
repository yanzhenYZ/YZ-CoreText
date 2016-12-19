//
//  ChatFrame.h
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ChatMessageType) {
    ChatMessageTypeText,
    ChatMessageTypePicture,
    ChatMessageTypeFile,
    ChatMessageTypeAudio,
    ChatMessageTypeVideo
};

@class ChatModel;
@interface ChatFrame : NSObject
@property (nonatomic, strong, readonly) ChatModel *chatModel;
/**           头像的frame              */
@property (nonatomic, assign, readonly) CGRect headIVFrame;
/**           头像的frame              */
@property (nonatomic, assign) CGRect bubbleIVFrame;
@property (nonatomic, assign) CGFloat rowHeight;

@end

#pragma mark - ChatModel
@interface ChatModel : NSObject
/**          是发送还是接收            */
@property (nonatomic, assign) BOOL send;
//属性如果设为只读的话，子类只能通过self.rowHeight调用，只读属性不能用self.rowHeight
@property (nonatomic, assign) CGFloat rowHeight;
//每条消息的时间
@property (nonatomic, assign) long long dateTime;
//是否应该显示时间label - - 暂时未没有想好怎么做
@property (nonatomic, assign) BOOL showTimeLabel;

@property (nonatomic, assign, readonly) ChatMessageType messageType;

@end

//
//  EmojiToolbar.h
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EmojiToolbarButtonType) {
    EmojiToolbarButtonType_IMAGE = 100,
    EmojiToolbarButtonType_EMOJI,
    EmojiToolbarButtonType_GIF,
};

@protocol EmojiToolbarDelegate <NSObject>

- (void)emojiToolbarButtonClick:(EmojiToolbarButtonType)type;

@end

@class EmojiSendButton;
@interface EmojiToolbar : UIView
//为聊天设计
@property (nonatomic, strong, readonly) EmojiSendButton *sendBtn;//default hidden is YES.
@property (nonatomic, weak) id<EmojiToolbarDelegate>delegate;
@end

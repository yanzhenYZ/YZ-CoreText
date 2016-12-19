//
//  ChatToolbar.h
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHATTOOLBARTYPE) {
    CHATTOOLBARTYPE_NORMAL,
    CHATTOOLBARTYPE_KEYBOARD,
    CHATTOOLBARTYPE_RECORDING,
    CHATTOOLBARTYPE_EMOJI,
    CHATTOOLBARTYPE_MORE
};

@protocol ChatToolbarDelegate <NSObject>

- (void)toolBarButtonClick:(CHATTOOLBARTYPE)type;
- (void)sendMessage:(NSString *)message;
- (void)textViewContentSizeChanged;
- (void)textViewTextDidChange;
@end

@class ToolbarTextView;
@interface ChatToolbar : UIView
@property (nonatomic, weak, readonly) UIButton *recordBtn;
@property (nonatomic, weak, readonly) ToolbarTextView *textView;
@property (nonatomic, weak, readonly) UIButton *voiceBtn;
@property (nonatomic, weak, readonly) UIButton *emojiBtn;
@property (nonatomic, weak, readonly) UIButton *moreBtn;
@property (nonatomic, weak) id<ChatToolbarDelegate> delegate;
@property (nonatomic, assign) CHATTOOLBARTYPE type;
@end

//
//  ComposeTextView.h
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmojiModel;
@interface ComposeTextView : UITextView
//插入图片会导致font大小改变，所以需要记录font大小
@property (nonatomic, strong) UIFont *normalFont;

- (void)insertEmoji:(EmojiModel *)emoji;
//返回纯文本
- (NSString *)plainText;
@end

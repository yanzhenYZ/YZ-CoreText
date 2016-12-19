//
//  EmojiKeyboard.h
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

//包含两部分
//底部toolbar
//上面部分显示小图片，emoji，gif
@class EmojiToolbar;
@interface EmojiKeyboard : UIView
//为了拿到sendBtn
@property (nonatomic, strong, readonly) EmojiToolbar *toolBar;
@end

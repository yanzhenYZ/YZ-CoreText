//
//  EmojiButton.m
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiButton.h"
#import "EmojiModel.h"

@implementation EmojiButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        
        // 按钮高亮的时候。不要去调整图片（不要调整图片会灰色）
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}


-(void)setEmojiModel:(EmojiModel *)emojiModel{
    _emojiModel = emojiModel;
    if (emojiModel.png) {
        [self setImage:[UIImage imageNamed:emojiModel.png] forState:UIControlStateNormal];
    }else if (emojiModel.code){
        [self setTitle:emojiModel.code.emoji forState:UIControlStateNormal];
    }
}
@end

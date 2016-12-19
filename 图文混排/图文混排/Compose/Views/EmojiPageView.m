
//
//  EmojiPageView.m
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiPageView.h"
#import "EmojiButton.h"

@interface EmojiPageView ()
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation EmojiPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [_deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

-(void)setEmojis:(NSArray *)emojis{
    _emojis = emojis;
    NSUInteger count = emojis.count;
    for (int i = 0; i<count; i++) {
        EmojiButton *btn = [[EmojiButton alloc] init];
        [self addSubview:btn];
        btn.emojiModel = emojis[i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//由于view的层次较深所以选择发送通知
- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EMOJIPAGEVIEWDIDDELETEEMOJI object:nil];
}

- (void)btnClick:(EmojiButton *)btn
{
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[EMOJIDIDSELECTEDKEY] = btn.emojiModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:EMOJIPAGEVIEWDIDSELECTEDEMOJI object:nil userInfo:userInfo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat inset = 20;
    NSUInteger count = self.emojis.count;
    CGFloat btnW = (self.width - 2 * inset) / EmojiCol;
    CGFloat btnH = (self.height - inset) / EmojiRow;
    for (int i = 0; i<count; i++) {
        //第一个是deleteBtn
        UIButton *btn = self.subviews[i + 1];
        CGFloat x = inset + (i % EmojiCol) * btnW;
        CGFloat y = inset + (i / EmojiCol) *btn.height;
        btn.frame = CGRectMake(x, y, btnW, btnH);
    }
    self.deleteBtn.frame = CGRectMake(self.width - inset - btnW, self.height - btnH, btnW, btnH);
}
@end

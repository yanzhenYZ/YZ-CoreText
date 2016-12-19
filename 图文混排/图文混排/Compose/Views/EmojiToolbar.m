//
//  EmojiToolbar.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiToolbar.h"
#import "EmojiToolbarButton.h"
#import "EmojiSendButton.h"

@interface EmojiToolbar ()
@property (nonatomic, strong) EmojiToolbarButton *selectBtn;
@property (nonatomic, strong) EmojiToolbarButton *imageBtn;
@property (nonatomic, strong) EmojiToolbarButton *emojiBtn;
@property (nonatomic, strong) EmojiToolbarButton *gifBtn;
@end

@implementation EmojiToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *imageNames = @[@"compose_emotion_table_default",@"compose_emotion_table_emoji",@"compose_emotion_table_hot"];
        NSArray *backDisableINs = @[@"compose_emotion_table_left_selected",@"compose_emotion_table_mid_selected",@"compose_emotion_table_right_selected"];
        EmojiToolbarButton *(^btnBlock)(EmojiToolbarButtonType type) = ^(EmojiToolbarButtonType type){
            EmojiToolbarButton *btn = [EmojiToolbarButton buttonWithType:UIButtonTypeCustom];
            btn.tag = type;
            NSInteger index = type - 100;
            [btn setImage:[UIImage imageNamed:imageNames[index]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:backDisableINs[index]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        };
        
        _imageBtn = btnBlock(EmojiToolbarButtonType_IMAGE);
        _emojiBtn = btnBlock(EmojiToolbarButtonType_EMOJI);
        _gifBtn   = btnBlock(EmojiToolbarButtonType_GIF);
        [self addSubview:_imageBtn];
        [self addSubview:_emojiBtn];
        [self addSubview:_gifBtn];
        
#pragma mark - 1.0.3.2 ②
        _sendBtn = [[EmojiSendButton alloc] init];
        
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn setTitleColor:FYColor(135, 135, 135) forState:UIControlStateDisabled];
        _sendBtn.hidden = YES;
        _sendBtn.enabled = NO;
        [self addSubview:_sendBtn];
        
        
        //主动选中默认的一项
        _selectBtn = _imageBtn;
        [self btnClick:_imageBtn];
    }
    return self;
}



- (void)btnClick:(EmojiToolbarButton *)btn{
    if (btn.selected) return;
    _selectBtn.selected = NO;
    btn.selected = YES;
    _selectBtn = btn;
    if ([_delegate respondsToSelector:@selector(emojiToolbarButtonClick:)]) {
        [_delegate emojiToolbarButtonClick:btn.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = 60;
    _imageBtn.frame = CGRectMake((_imageBtn.tag - 100) * width, 0, width, self.height);
    _emojiBtn.frame = CGRectMake((_emojiBtn.tag - 100) * width, 0, width, self.height);
    _gifBtn.frame = CGRectMake((_gifBtn.tag - 100) * width, 0, width, self.height);
    _sendBtn.frame = CGRectMake(self.width - width, 0, width, self.height);
}

//compose_emotion_table_default
//compose_emotion_table_emoji
//compose_emotion_table_hot
@end

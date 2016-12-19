//
//  ChatToolbar.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatToolbar.h"
#import "ToolbarTextView.h"

@interface ChatToolbar ()<UITextViewDelegate>
@property (nonatomic, assign) BOOL recording;

@end

@implementation ChatToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - Action
- (void)emojiBtnClick:(UIButton *)emojiBtn{
    if (_recording) return;
    emojiBtn.selected = !emojiBtn.selected;
    if ([_delegate respondsToSelector:@selector(toolBarButtonClick:)]) {
        [_delegate toolBarButtonClick:CHATTOOLBARTYPE_EMOJI];
    }
}

- (void)recordBtnClick:(UIButton *)btn{
    if (_recording) return;
    btn.selected = !btn.selected;
    if ([_delegate respondsToSelector:@selector(toolBarButtonClick:)]) {
        [_delegate toolBarButtonClick:CHATTOOLBARTYPE_RECORDING];
    }
}

- (void)moreBtnClick:(UIButton *)btn{
    if (_recording) return;
    if ([_delegate respondsToSelector:@selector(toolBarButtonClick:)]) {
        [_delegate toolBarButtonClick:CHATTOOLBARTYPE_MORE];
    }
}

- (void)recordDone:(UIButton *)btn{
    [btn setTitle:@"按住说话" forState:UIControlStateNormal];
    _recording = NO;
}

- (void)recordCancel:(UIButton *)btn{
    [btn setTitle:@"按住说话" forState:UIControlStateNormal];
    _recording = NO;
}

- (void)recording:(UIButton *)btn{
    [btn setTitle:@"松开结束" forState:UIControlStateNormal];
    _recording = YES;
}

- (void)cancelRecord:(UIButton *)btn{
    [btn setTitle:@"松开手指，取消发送" forState:UIControlStateNormal];
    _recording = YES;
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if ([_delegate respondsToSelector:@selector(sendMessage:)]) {
            [_delegate sendMessage:self.textView.text];
        }
        self.textView.text = nil;
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(textViewTextDidChange)]) {
        [_delegate textViewTextDidChange];
    }
}

#pragma mark - keyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.textView && [keyPath isEqualToString:@"contentSize"]) {
        if ([_delegate respondsToSelector:@selector(textViewContentSizeChanged)]) {
            [_delegate textViewContentSizeChanged];
        }
    }
}
#pragma mark - UI
- (void)configUI{
    self.backgroundColor = FYColor(244, 244, 246);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = FYColor(196, 196, 196).CGColor;
    UIButton *recordBtn = [[UIButton alloc] init];
    [recordBtn setImage:[UIImage imageNamed:@"message_voice_background"] forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateSelected];
    [recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recordBtn];
    _recordBtn = recordBtn;
    
    ToolbarTextView *textView = [[ToolbarTextView alloc] init];
    [self corner:textView];
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    textView.delegate = self;
    [self addSubview:textView];
    _textView = textView;
    
    UIButton *voiceBtn = [[UIButton alloc] init];
    [self corner:voiceBtn];
    voiceBtn.backgroundColor = _textView.backgroundColor;
    [voiceBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [voiceBtn setTitleColor:FYColor(255, 155, 23) forState:UIControlStateNormal];
    voiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    voiceBtn.hidden = YES;
    //语音的一些处理
    [voiceBtn addTarget:self action:@selector(recordDone:) forControlEvents:UIControlEventTouchUpInside];
    [voiceBtn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [voiceBtn addTarget:self action:@selector(recording:) forControlEvents:UIControlEventTouchDragInside];
    [voiceBtn addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchDragOutside];
    [self addSubview:voiceBtn];
    _voiceBtn = voiceBtn;
    
    UIButton *emojiBtn = [[UIButton alloc] init];
    [emojiBtn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [emojiBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    [emojiBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateSelected];
    [self addSubview:emojiBtn];
    _emojiBtn = emojiBtn;
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"compose_toolbar_more"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"compose_toolbar_more_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:moreBtn];
    _moreBtn = moreBtn;
}

- (void)corner:(UIView *)view{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = FYColor(196, 196, 196).CGColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h = self.height;
    _recordBtn.frame = CGRectMake(0, h - CHATTOOLBARHEIGHT, CHATTOOLBARHEIGHT, CHATTOOLBARHEIGHT);
    _moreBtn.frame = CGRectMake(self.width - CHATTOOLBARHEIGHT, _recordBtn.y, CHATTOOLBARHEIGHT, CHATTOOLBARHEIGHT);
    _emojiBtn.frame = CGRectMake(self.width - CHATTOOLBARHEIGHT * 2, _recordBtn.y, CHATTOOLBARHEIGHT, CHATTOOLBARHEIGHT);
    _textView.frame = CGRectMake(_recordBtn.width, 5, self.width - _recordBtn.width * 3, self.height - 10);
    _voiceBtn.frame = CGRectMake(_textView.x, self.height - CHATTOOLBARHEIGHT + 5, _textView.width, CHATTOOLBARHEIGHT - 10);
}

-(void)dealloc{
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}
@end

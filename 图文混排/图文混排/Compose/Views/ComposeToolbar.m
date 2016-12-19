//
//  ComposeToolbar.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ComposeToolbar.h"

@interface ComposeToolbar ()
@property (nonatomic, strong) UIButton *emojBtn;

@end

@implementation ComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        UIButton *(^btnBlock)(NSString *imageName,NSInteger tag) = ^(NSString *imageName,NSInteger tag){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *hlImageName = [imageName stringByAppendingString:@"_highlighted"];
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
            btn.tag = tag;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        };
        _emojBtn = btnBlock(@"compose_emoticonbutton_background",ComposeToolbarButtonType_EMOJ);
        
        [self addSubview:btnBlock(@"compose_toolbar_picture",ComposeToolbarButtonType_PHOTO)];
        [self addSubview:btnBlock(@"compose_mentionbutton_background",ComposeToolbarButtonType_AT)];
        [self addSubview:btnBlock(@"compose_trendbutton_background",ComposeToolbarButtonType_TREND)];
        [self addSubview:_emojBtn];
        [self addSubview:btnBlock(@"compose_toolbar_more",ComposeToolbarButtonType_MORE)];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn{
    NSLog(@"ComposeToolbarButtonType:%ld",btn.tag);
    if (ComposeToolbarButtonType_EMOJ == btn.tag) {
        if ([_delegate respondsToSelector:@selector(composeToolbarDidClick:)]) {
            [_delegate composeToolbarDidClick:btn.tag];
        }
    }
}
-(void)setShowKeyBoardImage:(BOOL)showKeyBoardImage{
    _showKeyBoardImage = showKeyBoardImage;
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    // 显示键盘图标
    if (showKeyBoardImage) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    // 设置图片
    [self.emojBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emojBtn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}
#pragma mark - UI
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.width / 5;
    for (UIButton *btn in self.subviews) {
        CGFloat x = btn.tag * width;
        btn.frame = CGRectMake(x, 0, width, 44.0);
    }
}

@end

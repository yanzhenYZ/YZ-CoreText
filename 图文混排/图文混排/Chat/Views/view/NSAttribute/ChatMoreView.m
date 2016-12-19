//
//  ChatMoreView.m
//  图文混排
//
//  Created by yanzhen on 16/11/14.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatMoreView.h"

@interface ChatMoreView ()
//@property (weak, nonatomic) UIButton *imageBtn;

@end

@implementation ChatMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"图片",@"gif"];
        UIButton *(^BtnBlock)(NSInteger tag) = ^(NSInteger tag){
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:titles[tag - 100] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = tag;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 6.0;
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        };
        [self addSubview:BtnBlock(ChatMoreViewImage)];
        [self addSubview:BtnBlock(ChatMoreViewGif)];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(chatMoreViewBtnClick:)]) {
        [_delegate chatMoreViewBtnClick:btn.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIButton *btn in self.subviews) {
        NSInteger tag = btn.tag - 100;
        btn.frame = CGRectMake(10 + 70 * tag, 10, 60, 60);
    }
}

@end

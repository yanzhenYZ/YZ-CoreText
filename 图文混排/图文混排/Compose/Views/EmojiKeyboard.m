//
//  EmojiKeyboard.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiKeyboard.h"
#import "EmojiToolbar.h"
#import "EmojiListView.h"
#import "EmojiManage.h"

@interface EmojiKeyboard ()<EmojiToolbarDelegate>
@property (nonatomic, strong) EmojiListView *showListView;
@property (nonatomic, strong) EmojiListView *emojiListView;
@property (nonatomic, strong) EmojiListView *imageListView;
@property (nonatomic, strong) EmojiListView *gifListView;
@end

@implementation EmojiKeyboard

-(EmojiListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView = [[EmojiListView alloc] init];
        _emojiListView.emojis = [EmojiManage allEmojis];
    }
    return _emojiListView;
}

-(EmojiListView *)gifListView{
    if (!_gifListView) {
        _gifListView = [[EmojiListView alloc] init];
        _gifListView.emojis = [EmojiManage allGifs];
    }
    return _gifListView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FYColor(239, 236, 237);
        _toolBar = [[EmojiToolbar alloc] init];
        _toolBar.delegate = self;
        [self addSubview:_toolBar];
        
        _imageListView = [[EmojiListView alloc] init];
        _imageListView.emojis = [EmojiManage allImages];
        [self addSubview:_imageListView];
        _showListView = _imageListView;
    }
    return self;
}
#pragma mark - EmojiToolbarDelegate
-(void)emojiToolbarButtonClick:(EmojiToolbarButtonType)type{
    [self.showListView removeFromSuperview];
    if (EmojiToolbarButtonType_IMAGE == type) {
        [self addSubview:self.imageListView];
    }else if (EmojiToolbarButtonType_EMOJI == type){
        [self addSubview:self.emojiListView];
    }else if (EmojiToolbarButtonType_GIF == type){
        [self addSubview:self.gifListView];
    }
    self.showListView = self.subviews.lastObject;
    [self setNeedsLayout];
}
#pragma mark - UI
-(void)layoutSubviews{
    [super layoutSubviews];
    _showListView.frame = CGRectMake(0, 0, self.width, self.height - 37.0);
    _toolBar.frame = CGRectMake(0, _showListView.height, self.width, 37);
    
}
@end

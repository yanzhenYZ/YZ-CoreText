//
//  ToolbarTextView.m
//  图文混排
//
//  Created by yanzhen on 16/11/17.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ToolbarTextView.h"
#import "EmojiManage.h"

@implementation ToolbarTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setProperty];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setProperty];
    }
    return self;
}

- (void)setProperty{
    self.returnKeyType = UIReturnKeySend;
#pragma mark - 1.0.3.2 ①
    self.enablesReturnKeyAutomatically = YES;
    self.font = ToolbarTextViewFont;
//    self.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    //UIEdgeInsetsMake(0, -5, 0, -5);
}

#pragma mark - 1.0.3.1
-(void)deleteBackward{
//    //① 正常删除
//    [super deleteBackward];
    
    //② 删除图片的全部内容
    /*
     1.当前选中在文字的最后面才去判断最后是否图片文字(多喝水[大笑])--WeChat
     2.选中长度为零
     3.判断最后面是否为图片的文字内容([测试]不可以)
     */
    if (self.selectedRange.location == self.text.length && self.selectedRange.length == 0) {
        NSString *lastStr = [self.text substringWithRange:NSMakeRange(self.text.length - 1, 1)];
        if ([lastStr isEqualToString:@"]"]) {
            NSMutableString *string = [[NSMutableString alloc] initWithString:self.text];
            //测试[大笑][哼]
            //这里可以限制开始判断的地方和判断的长度
            for (NSInteger i = string.length - 3; i >= 0; i--) {
                unichar ch = [string characterAtIndex:i];
                if ('[' == ch) {
                    NSRange imageRange = NSMakeRange(i, string.length - i);
                    NSString *imageStr = [string substringWithRange:imageRange];
                    if ([EmojiManage isImageWithChs:imageStr]) {
                        [string deleteCharactersInRange:imageRange];
                        self.text = string;
#pragma mark - 1.0.3.2.20 不调用[super deleteBackward]代理textViewDidChange不会触发
                        if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
                            [self.delegate textViewDidChange:self];
                        }
                        return;
                    }
                }
            }
        }
    }
    [super deleteBackward];
}

@end

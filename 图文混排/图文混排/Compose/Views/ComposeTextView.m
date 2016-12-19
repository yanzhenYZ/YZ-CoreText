//
//  ComposeTextView.m
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ComposeTextView.h"
#import "EmojiTextAttachment.h"
#import "EmojiModel.h"

@implementation ComposeTextView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        
//    }
//    return self;
//}
//
//- (void)test{
//    self.editable = NO;
//    self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
//    // 禁止滚动, 让文字完全显示出来
//    self.scrollEnabled = NO;
//}

- (void)insertEmoji:(EmojiModel *)emoji{
    if (emoji.code) {
        [self insertText:emoji.code.emoji];
    }else if (emoji.png){
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
        [attributeString appendAttributedString:self.attributedText];
        
        EmojiTextAttachment *attachment = [[EmojiTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:emoji.png];
        attachment.emoji = emoji;
#pragma mark - (font=20)spcae较为合适
//        CGFloat space = 4;
//        CGFloat wh = self.normalFont.lineHeight - space / 2;
        //继承比这个方法好用
//        attachment.bounds = CGRectMake(-space, -space, wh, wh);
        
        //以前的资料？？？？？？？
//        CGFloat wh = self.normalFont.lineHeight;
//        attachment.bounds = CGRectMake(-4, 0, wh, wh);
        attachment.imageWH = self.normalFont.lineHeight;
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attachment];

        
        
#pragma mark - 1
        //确定当前光标的位置
        NSUInteger location = self.selectedRange.location;
        //把要插入的image插入当前选中的位置
        [attributeString replaceCharactersInRange:self.selectedRange withAttributedString:imageString];
        
        //插入图片之后要恢复NSFontAttributeName
        [attributeString addAttribute:NSFontAttributeName value:self.normalFont range:NSMakeRange(0, attributeString.length)];
        self.attributedText = attributeString;
        //插入图片之后让光标后移一位
        self.selectedRange = NSMakeRange(location + 1, 0);
        
#pragma mark - 2
//        NSUInteger location = self.selectedRange.location;
//        [self.textStorage insertAttributedString:imageString atIndex:location];
//        self.selectedRange = NSMakeRange(location + 1, self.selectedRange.length);
//        NSRange wholeRange = NSMakeRange(0, self.textStorage.length);
//        //暴力恢复NSFontAttributeName
//        [self.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
//        [self.textStorage addAttribute:NSFontAttributeName value:self.normalFont range:wholeRange];
    }
}


-(NSString *)plainText{
    NSMutableString *plainText = [[NSMutableString alloc] init];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        //苹果自带的key值
        EmojiTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {
            [plainText appendString:attachment.emoji.chs];
        }else{
            NSAttributedString *attributedString = [self.attributedText attributedSubstringFromRange:range];
            [plainText appendString:attributedString.string];
        }
    }];
    return plainText;
}

@end

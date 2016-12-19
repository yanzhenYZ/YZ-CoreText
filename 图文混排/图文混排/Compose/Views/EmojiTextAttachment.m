//
//  EmojiTextAttachment.m
//  图文混排
//
//  Created by yanzhen on 16/11/4.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex{
    //????---当textView.font = 17的时候，space=0
    //当textView.font = 20的时候，下面space = textContainer.lineFragmentPadding / 2
    CGFloat space = 0 / 2;
#pragma mark - Emoji表情占据的空间宽>高，要保持图片和emoji占据同样的空间必须进行相应的设计-(暂未解决)
    return CGRectMake(0, -4, self.imageWH - space, self.imageWH - space);
//    return CGRectMake(0, -4, 23, self.imageWH - space);
}

//-(UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex{
//    NSLayoutManager *layoutManager = textContainer.layoutManager;
//    NSLog(@"NSLayoutManager:%@",layoutManager);
////    NSLog(@"imageBounds:%@",NSStringFromCGRect(imageBounds));
//    return self.image;
//}
@end

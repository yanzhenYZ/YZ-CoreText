//
//  ChatCoreTextFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/24.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatCoreTextFrame.h"
#import "CoreTextModel.h"
#import "EmojiManage.h"
#import <CoreText/CoreText.h>

@implementation ChatCoreTextFrame

-(ChatModel *)chatModel{
    return _textModel;
}

-(void)setTextModel:(ChatCoreTextModel *)textModel{
    _textModel = textModel;
    CGSize size = [self calculateCoreTextSize:textModel.attributedString];
    CGFloat headSpace = HEADIMAGESPACE * 2 + HEADVIEWWH;
    CGFloat tX = textModel.send ? CHATTEXTVIEWSPACE : CHATIMAGESPACE + CHATTEXTVIEWSPACE;
    _textViewFrame = CGRectMake(tX, CHATTEXTVIEWSPACE, size.width, size.height);
    //气泡
    CGFloat cW = size.width + (CHATIMAGESPACE + CHATTEXTVIEWSPACE * 2);
    tX = textModel.send ? WIDTH - cW - headSpace : headSpace;
    self.bubbleIVFrame = CGRectMake(tX, HEADIMAGESPACE, cW, size.height + 2 * CHATTEXTVIEWSPACE);
    self.rowHeight = CGRectGetMaxY(self.bubbleIVFrame) + HEADIMAGESPACE;
}

- (CGSize)calculateCoreTextSize:(NSAttributedString *)attributedString{
    CGFloat headSpace = HEADIMAGESPACE * 2 + HEADVIEWWH;
    
    CGFloat width = WIDTH - headSpace * 2 - CHATIMAGESPACE - 2 * CHATTEXTVIEWSPACE;
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, width, MAXFLOAT));
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFArrayRef lineArray = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lineArray);
    
    if (lineCount == 1) {
        CFRange range;
#pragma mark - 1.0.7.1.2
        //CTFramesetterSuggestFrameSizeWithConstraints字符串最后面的空格不会计算
        CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, attributedString.string.length), nil, CGSizeMake(WIDTH, MAXFLOAT), &range);
        //必须+1不然会显示不完全
        width = size.width + 1;
    }
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    
    CGFloat frameHeight = lineCount * (CoreTextFont.lineHeight + CoreTextLineSpace)+ CoreTextLineSpace;
    return CGSizeMake(width, roundf(frameHeight));
}

@end

#pragma mark - ChatCoreTextModel

static void RunDelegateDeallocateCallback(void *ref)
{
    
}

static CGFloat RunDelegateGetAscentCallback(void *ref)
{
    return CoreTextFont.ascender;
}

static CGFloat RunDelegateGetDescentCallback(void *ref)
{
    return CoreTextFont.descender;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    return CoreTextFont.lineHeight;
}


@implementation ChatCoreTextModel
-(ChatMessageType)messageType{
    return ChatMessageTypeText;
}

-(void)setText:(NSString *)text{
    _text = text;
    NSMutableAttributedString *attributedString = [self createAttributedStringWithText:text];
    [self regularAttributedString:attributedString];
    _attributedString = attributedString;
}

- (void)regularAttributedString:(NSMutableAttributedString *)attributedString{
    NSString *text = attributedString.mutableString;
    NSString *regulaStr = [NSString stringWithFormat:@"(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))",@"%",@"%",@"%",@"%"];
    
    NSArray *patternArray = @[@"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]",@"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+",@"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#",regulaStr];
    //@"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"
    NSMutableArray *rangeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < patternArray.count; i++) {
        NSString *pattern = patternArray[i];
        NSError *error;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error) {
            [regular enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                NSString *content = [text substringWithRange:result.range];
                CoreTextModel *model = [[CoreTextModel alloc] init];
                model.type = i;
                model.text = content;
                model.range = result.range;
                if (i == 0) {
                    if ([EmojiManage isImageWithChs:content]) {
                        [rangeArray addObject:model];
                    }
                }else{
                    [rangeArray addObject:model];
                }
            }];
        }
    }
    //升序排列
    [rangeArray sortUsingComparator:^NSComparisonResult(CoreTextModel *obj1, CoreTextModel *obj2) {
        return obj1.range.location > obj2.range.location;
    }];

    unichar replaceChar = 0xFFFC;
    __block NSString * replacString = [NSString stringWithCharacters:&replaceChar length:1];
    __block NSInteger sumSubtract = 0;
    
    [rangeArray enumerateObjectsUsingBlock:^(CoreTextModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSMakeRange(model.range.location - sumSubtract, model.range.length);
        NSDictionary *attributes = @{};
        if (CoreTextType_IMAGE == model.type) {
            CTRunDelegateCallbacks imageCallbacks;
            imageCallbacks.version    = kCTRunDelegateVersion1;
            imageCallbacks.dealloc    = RunDelegateDeallocateCallback;
            imageCallbacks.getAscent  = RunDelegateGetAscentCallback;
            imageCallbacks.getDescent = RunDelegateGetDescentCallback;
            imageCallbacks.getWidth   = RunDelegateGetWidthCallback;
#pragma mark - 1.0.7.1.1
            //占位符不能使用空格，如果结尾是空格的话，coretext计算一行的宽度会出错(不计算结尾的空格)
            [attributedString replaceCharactersInRange:range withString:replacString];
            range.length = 1;
            
            CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(self));
            [attributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
            CFRelease(runDelegate);
            [attributedString addAttribute:SPECIALSMARK value:model range:range];
            //只有图片会减少文字内容
            sumSubtract += model.text.length - 1;
        }else if (CoreTextType_AT == model.type){
            attributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,SPECIALSMARK : model};
        }else if (CoreTextType_TOPIC == model.type){
            attributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[UIColor greenColor].CGColor,SPECIALSMARK : model};
        }else if (CoreTextType_HTTP == model.type){
            attributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[UIColor blueColor].CGColor,(NSString *)kCTUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle),SPECIALSMARK : model};
        }
        [attributedString addAttributes:attributes range:range];
    }];
}

- (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    UIFont *font = CoreTextFont;
    CGFloat lineSpace = CoreTextLineSpace;
    NSRange range = NSMakeRange(0, attributedString.length);
    //设置字体格式
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
    CFRelease(fontRef);
    //设置字体颜色
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)CoreTextColor.CGColor range:range];
    //设置字体间距
//    [attributedString addAttribute:(NSString *)kCTKernAttributeName value:@0 range:range];
    
    //设置换行模式
    CTParagraphStyleSetting lineBreakStyle;
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    lineBreakStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineBreakStyle.value = &lineBreakMode;
    lineBreakStyle.valueSize = sizeof(CTLineBreakMode);
    //设置行间距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.value = &lineSpace;
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakStyle};
    CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    [attributedString addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(id)paragraphStyleRef range:range];
    CFRelease(paragraphStyleRef);
    return attributedString;
}
@end

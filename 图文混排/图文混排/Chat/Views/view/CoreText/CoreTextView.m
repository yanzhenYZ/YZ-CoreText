//
//  CoreTextView.m
//  图文混排
//
//  Created by yanzhen on 16/11/24.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "CoreTextView.h"
#import "ChatCoreTextFrame.h"
#import "CoreTextModel.h"
#import "EmojiManage.h"
#import "OLImage.h"
#import "OLImageView.h"
#import <CoreText/CoreText.h>

static const CGFloat HighlightBackgroundRadius = 4.0;
#define HighlightBackgroundColor [UIColor grayColor]

@interface CoreTextView ()
//key-rect object-model
@property (nonatomic, strong) NSMutableDictionary *rectModelDict;
//key-model object-rects
@property (nonatomic, strong) NSMutableDictionary *modelRectsDict;
@property (nonatomic, strong) NSArray *selectedRects;
@end

@implementation CoreTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _rectModelDict  = [[NSMutableDictionary alloc] init];
        _modelRectsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)setModel:(ChatCoreTextModel *)model{
    _model  = model;
    [self setNeedsDisplay];
}

//tableView复用
-(void)setNeedsDisplay{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [super setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    if (self.model.text.length <= 0) return;
    [self.rectModelDict removeAllObjects];
    [self.modelRectsDict removeAllObjects];
    UIFont *font = CoreTextFont;
    CGFloat lineSpace = CoreTextLineSpace;
    NSAttributedString *attributedString = self.model.attributedString;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    //    //下面是把坐标系从左下角--左上角
    CGContextTranslateCTM(contextRef, 0, self.height);
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    //坐标点在左下角
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, self.width, MAXFLOAT));
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFArrayRef lineArray = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lineArray);
    
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    //绘制高亮区域
    [self drawHighlightPath:contextRef];
    //
    CGFloat lineHeight = font.lineHeight + lineSpace;
    for (NSInteger i = 0; i < lineCount; i++) {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineArray, i);
        CGPoint lineOrigin = lineOrigins[i];
        
        //http://blog.csdn.net/fengsh998/article/details/8701738
        //font.descender -- 字体超出baseLine的高度
        //descent（下行高度）从原点到字体中最深的字形底部的距离，descent是一个负值（比如一个字体原点到最深的字形的底部的距离为2，那么descent就为-2）
        //坐标系原点在左下角---
        lineOrigin.y = self.height - (i + 1) * lineHeight - font.descender;
        CGContextSetTextPosition(contextRef, lineOrigin.x, lineOrigin.y);
        CTLineDraw(lineRef, contextRef);
        
        CFArrayRef glyphRuns =  CTLineGetGlyphRuns(lineRef);
        for (NSInteger j = 0; j < CFArrayGetCount(glyphRuns); j++) {
            CTRunRef runRef = CFArrayGetValueAtIndex(glyphRuns, j);
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(runRef);
            CoreTextModel *model = [attributes objectForKey:SPECIALSMARK];
            if (!model) continue;
            
            CGFloat ascent,descent;
            CGFloat runWidth = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &descent, NULL);
            CGFloat runX = lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
            CGFloat runY = lineOrigin.y + font.descender;
            CGRect keyRect = CGRectZero;
            if (model.type == CoreTextType_IMAGE) {
                CGFloat imageWH = CoreTextFont.lineHeight;
                keyRect = CGRectMake(runX, runY, imageWH,imageWH);
                NSString * imageName = [EmojiManage getImageName:model.text];
                if ([EmojiManage isGif:model.text]) {
#pragma mark - 1.0.7.2.1 -- gif 
                    //非常影响性能
                    OLImageView *imageView = [[OLImageView alloc] initWithFrame:keyRect];
                    imageName = [imageName substringToIndex:imageName.length - 4];
                    imageName = [imageName stringByAppendingString:@".gif"];
                    imageView.image = [OLImage imageNamed:imageName];
                    [self addSubview:imageView];
                }else{
                    
                    //如果需要--考虑图片不存在的情况
                    UIImage *image = [UIImage imageNamed:imageName];
                    CGContextDrawImage(contextRef, keyRect, image.CGImage);
                }
            }else{
                keyRect = CGRectMake(runX, runY - lineSpace / 2, runWidth, lineHeight);
                NSMutableArray *keyRects = [self.modelRectsDict objectForKey:model];
                if (!keyRects) keyRects = [[NSMutableArray alloc] init];
                __block BOOL add = YES;
                [keyRects enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL * _Nonnull stop) {
                    CGRect rect = value.CGRectValue;
                    if (rect.origin.y == keyRect.origin.y) {
                        //#你不懂#--如果在同一行会拼接两次次  -#-你不懂-#-
                        //如果不在同一行就会添加到数组中
                        rect.size.width += keyRect.size.width;
                        [keyRects replaceObjectAtIndex:idx withObject:[NSValue valueWithCGRect:rect]];
                        add = NO;
                        *stop = YES;
                    }
                }];
                NSValue *keyValue = [NSValue valueWithCGRect:keyRect];
                if (add) {
                    [keyRects addObject:keyValue];
                }
                [self.modelRectsDict setObject:keyRects forKey:model];
                [self.rectModelDict setObject:model forKey:keyValue];
            }
            
        }
    }
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
}

- (void)drawHighlightPath:(CGContextRef)contextRef{
    [self.selectedRects enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.CGRectValue;
        CGPathRef pathRef = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:HighlightBackgroundRadius].CGPath;
        CGContextSetFillColorWithColor(contextRef, HighlightBackgroundColor.CGColor);
        CGContextAddPath(contextRef, pathRef);
        CGContextFillPath(contextRef);
    }];
}

#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint selectedPoint = [self getTouchsPoint:touches];
    [self.rectModelDict enumerateKeysAndObjectsUsingBlock:^(NSValue *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        CGRect rect = key.CGRectValue;
        if(CGRectContainsPoint(rect, selectedPoint))
        {
            self.selectedRects = [self.modelRectsDict objectForKey:obj];
            [self setNeedsDisplay];
            *stop = YES;
        }
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint selectedPoint = [self getTouchsPoint:touches];
    [self.rectModelDict enumerateKeysAndObjectsUsingBlock:^(NSValue *key, CoreTextModel *obj, BOOL * _Nonnull stop) {
        CGRect rect = key.CGRectValue;
        if(CGRectContainsPoint(rect, selectedPoint))
        {
            if ([_delegate respondsToSelector:@selector(selectedSpecialRegion:)]) {
                [_delegate selectedSpecialRegion:obj];
            }
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.selectedRects) {
        self.selectedRects = nil;
        [self setNeedsDisplay];
    }
}

- (CGPoint)getTouchsPoint:(NSSet<UITouch *> *)touches{
    CGPoint location = [[touches anyObject] locationInView:self];
    //重绘的坐标系原点在左下角
    return CGPointMake(location.x, self.height - location.y);
}
@end

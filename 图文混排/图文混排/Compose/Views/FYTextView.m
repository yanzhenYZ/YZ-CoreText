//
//  FYTextView.m
//  图文混排
//
//  Created by yanzhen on 16/11/8.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "FYTextView.h"
#import "CoreTextModel.h"

static const NSInteger BACKVIEWTAG = 1000;

@interface FYTextView ()
@property (nonatomic, strong) CoreTextModel *selectedModel;
@end

@implementation FYTextView

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
    self.editable = NO;
    self.scrollEnabled = NO;
    self.selectable = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);

}
#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSArray *marks = [self.attributedText attribute:SPECIALSMARK atIndex:0 effectiveRange:NULL];
    BOOL contains = NO;
    for (CoreTextModel *model in marks) {
        self.selectedRange = model.range;
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = NSMakeRange(0, 0);
        for (UITextSelectionRect *selectionRect in rects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            if (CGRectContainsPoint(rect, point)) {                 contains = YES;
                break;
            }
        }
        
        if (contains) {
            _selectedModel = model;
            //rects一般会包含宽或者高=0的情况
            //需要高亮的地方有时候会换行，所以会欧两个frame的情况
            for (UITextSelectionRect *selectionRect in rects) {
                CGRect rect = selectionRect.rect;
                if (rect.size.width == 0 || rect.size.height == 0) continue;
                
                UIView *backView = [[UIView alloc] init];
                backView.backgroundColor = [UIColor yellowColor];
                backView.frame = rect;
                backView.tag = BACKVIEWTAG;
                backView.layer.cornerRadius = 5;
                [self insertSubview:backView atIndex:0];
            }
            break;
        }
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
#pragma mark - 做要做的事情
    NSLog(@"TYPE:%ld",_selectedModel.type);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.subviews) {
        if (view.tag == BACKVIEWTAG) [view removeFromSuperview];
    }
    self.selectedModel = nil;
}
@end

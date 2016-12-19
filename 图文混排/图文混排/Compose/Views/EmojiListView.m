//
//  EmojiListView.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiListView.h"
#import "EmojiPageView.h"

@interface EmojiListView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation EmojiListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        //不建议使用下面这种方法
//        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
//        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        pageControl.currentPageIndicatorTintColor = FYColor(255, 155, 23);
        pageControl.pageIndicatorTintColor = FYColor(219, 219, 219);
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

-(void)setEmojis:(NSArray *)emojis{
    _emojis = emojis;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //20 的整数倍会多一页所以减去1
    NSInteger count = (emojis.count + EmojiPageSize - 1) / EmojiPageSize;
    self.pageControl.numberOfPages = count;
    for (NSInteger i = 0; i < count; i++) {
        EmojiPageView *pageView = [[EmojiPageView alloc] init];
        //计算每一个pageView的emoji
        NSRange range;
        range.location = i * EmojiPageSize;
        
        NSInteger leftCount = emojis.count - range.location;
        range.length = leftCount >= EmojiPageSize ? EmojiPageSize : leftCount;
        pageView.emojis = [_emojis subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pageControl.frame = CGRectMake(0, self.height - 25, self.width, 25);
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.pageControl.y);
    
    NSInteger count = self.scrollView.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        EmojiPageView *pageView = self.scrollView.subviews[i];
        pageView.frame = CGRectMake(self.scrollView.width * i, 0, self.scrollView.width, self.scrollView.height);
    }
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(index + 0.5);
}
@end

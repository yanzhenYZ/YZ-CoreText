//
//  NSObject+YZExtent.m
//
//  Created by yanzhen.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (YZExtent)

@end

@interface NSString (Emoji)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)code;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)code;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
@end

@interface UIView (GlobalCategorys)
/**            view.frame.origin.x                  */
@property (nonatomic, assign) CGFloat x;
/**            view.frame.origin.y                  */
@property (nonatomic, assign) CGFloat y;
/**            view.frame.size.width                */
@property (nonatomic, assign) CGFloat width;
/**            view.frame.size.height               */
@property (nonatomic, assign) CGFloat height;
/**            view.center.x                        */
@property (nonatomic, assign) CGFloat centerX;
/**            view.center.y                        */
@property (nonatomic, assign) CGFloat centerY;
/**            view.frame.size                      */
@property (nonatomic, assign) CGSize size;
/**            CGRectGetMaxX(self.frame)            */
@property (nonatomic, assign, readonly) CGFloat maxX;
/**            CGRectGetMaxY(self.frame)            */
@property (nonatomic, assign, readonly) CGFloat maxY;
@end

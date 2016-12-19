//
//  EmojiManage.h
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiManage : NSObject

+ (NSArray *)allImages;
+ (NSArray *)allEmojis;
+ (NSArray *)allGifs;
+ (NSString *)getImageName:(NSString *)chs;
+ (BOOL)isImageWithChs:(NSString *)chs;

+ (BOOL)isGif:(NSString *)chs;
@end

//
//  EmojiTextAttachment.h
//  图文混排
//
//  Created by yanzhen on 16/11/4.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmojiModel;
@interface EmojiTextAttachment : NSTextAttachment
@property (nonatomic, assign) CGFloat imageWH;
@property (nonatomic, strong) EmojiModel *emoji;
//@property (nonatomic, strong) UIImage *<#name#>;
@end

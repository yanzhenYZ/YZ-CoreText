//
//  EmojiPageView.h
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EmojiRow 3
#define EmojiCol 7
#define EmojiPageSize 20

@interface EmojiPageView : UIView
@property (nonatomic, strong) NSArray *emojis;
@end

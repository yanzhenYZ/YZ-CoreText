//
//  EmojiSendButton.m
//  图文混排
//
//  Created by yanzhen on 16/11/17.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiSendButton.h"

@implementation EmojiSendButton

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    self.backgroundColor = enabled ? FYColor(11, 95, 251) : FYColor(249, 249, 249);
}

@end

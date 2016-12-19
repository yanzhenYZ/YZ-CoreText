//
//  ChatFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatFrame.h"

@implementation ChatFrame
-(CGRect)headIVFrame{
    CGFloat headX = self.chatModel.send ? (WIDTH - HEADIMAGESPACE - HEADVIEWWH) : HEADIMAGESPACE;
    return CGRectMake(headX, HEADIMAGESPACE, HEADVIEWWH, HEADVIEWWH);
}
@end

#pragma mark - ChatModel

@implementation ChatModel
-(void)setShowTimeLabel:(BOOL)showTimeLabel{
    _showTimeLabel = showTimeLabel;
    
}
@end

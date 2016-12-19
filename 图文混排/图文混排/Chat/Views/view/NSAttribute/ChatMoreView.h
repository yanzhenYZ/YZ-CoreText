//
//  ChatMoreView.h
//  图文混排
//
//  Created by yanzhen on 16/11/14.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChatMoreViewType) {
    ChatMoreViewImage = 100,
    ChatMoreViewGif
};

@protocol ChatMoreViewDelegate <NSObject>

- (void)chatMoreViewBtnClick:(ChatMoreViewType)type;

@end

@interface ChatMoreView : UIView

@property (weak, nonatomic) id<ChatMoreViewDelegate> delegate;

@end

//
//  ComposeToolbar.h
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ComposeToolbarButtonType) {
    ComposeToolbarButtonType_PHOTO,
    ComposeToolbarButtonType_AT,
    ComposeToolbarButtonType_TREND,
    ComposeToolbarButtonType_EMOJ,
    ComposeToolbarButtonType_MORE,
};

@protocol ComposeToolbarDelegate <NSObject>

@optional
- (void)composeToolbarDidClick:(ComposeToolbarButtonType)toolbarButtonType;

@end

@interface ComposeToolbar : UIView
@property (nonatomic, weak) id<ComposeToolbarDelegate>delegate;
@property (nonatomic, assign) BOOL showKeyBoardImage;

@end

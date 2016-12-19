//
//  CoreTextView.h
//  图文混排
//
//  Created by yanzhen on 16/11/24.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatCoreTextModel;
@class CoreTextModel;
@protocol CoreTextViewDelegate <NSObject>

- (void)selectedSpecialRegion:(CoreTextModel *)model;

@end

@interface CoreTextView : UIView

@property (nonatomic, strong) ChatCoreTextModel *model;
@property (nonatomic, weak) id<CoreTextViewDelegate>delegate;
@end

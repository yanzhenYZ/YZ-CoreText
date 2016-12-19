//
//  ChatCellTextView.h
//  图文混排
//
//  Created by yanzhen on 16/11/11.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreTextModel;
@protocol ChatCellTextViewDelegate <NSObject>

@optional
- (void)didSelectedSpecial:(CoreTextModel *)textModel;

@end

@interface ChatCellTextView : UITextView
@property (nonatomic, weak) id<ChatCellTextViewDelegate> textDelegate;

@end

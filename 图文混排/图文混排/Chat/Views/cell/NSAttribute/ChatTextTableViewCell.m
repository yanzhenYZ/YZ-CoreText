//
//  ChatTextTableViewCell.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatTextTableViewCell.h"
#import "ChatCellTextView.h"
#import "ChatTextFrame.h"

@interface ChatTextTableViewCell ()<ChatCellTextViewDelegate>
@property (nonatomic, weak) ChatCellTextView *textView;
@end

@implementation ChatTextTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ChatCellTextView *textView = [[ChatCellTextView alloc] init];
        textView.textDelegate = self;
        [self.bubbleImageView addSubview:textView];
        _textView = textView;
    }
    return self;
}

-(void)setTextFrame:(ChatTextFrame *)textFrame{
    _textFrame = textFrame;
    self.headImageView.frame = textFrame.headIVFrame;
    self.bubbleImageView.frame = textFrame.bubbleIVFrame;
    self.textView.frame = textFrame.textViewFrame;
    UIImage *image = [UIImage imageNamed:textFrame.textModel.send ? @"sendMessageSelf" : @"receiveMessage"];
    self.bubbleImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 28, 10, 28) resizingMode:UIImageResizingModeStretch];
    self.textView.attributedText = textFrame.textModel.attributedString;
}
#pragma mark - ChatCellTextViewDelegate
-(void)didSelectedSpecial:(CoreTextModel *)textModel{
    if ([_delegate respondsToSelector:@selector(didSelectedSpecial:)]) {
        [_delegate didSelectedSpecial:textModel];
    }
}
@end

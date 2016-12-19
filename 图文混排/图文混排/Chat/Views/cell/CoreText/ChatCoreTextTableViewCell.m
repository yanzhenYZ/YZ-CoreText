//
//  ChatCoreTextTableViewCell.m
//  图文混排
//
//  Created by yanzhen on 16/11/24.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatCoreTextTableViewCell.h"
#import "ChatCoreTextFrame.h"
#import "CoreTextView.h"

@interface ChatCoreTextTableViewCell ()<CoreTextViewDelegate>

@property (weak, nonatomic) CoreTextView *textView;

@end

@implementation ChatCoreTextTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CoreTextView *textView = [[CoreTextView alloc] init];
        textView.delegate = self;
        [self.bubbleImageView addSubview:textView];
        _textView = textView;
    }
    return self;
}

-(void)setTextFrame:(ChatCoreTextFrame *)textFrame{
    _textFrame = textFrame;
    self.headImageView.frame = textFrame.headIVFrame;
    self.bubbleImageView.frame = textFrame.bubbleIVFrame;
    self.textView.frame = textFrame.textViewFrame;
    UIImage *image = [UIImage imageNamed:textFrame.textModel.send ? @"sendMessageSelf" : @"receiveMessage"];
    self.bubbleImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 28, 10, 28) resizingMode:UIImageResizingModeStretch];
    self.textView.model = textFrame.textModel;
}

#pragma mark - CoreTextViewDelegate
-(void)selectedSpecialRegion:(CoreTextModel *)model{
    if ([_delegate respondsToSelector:@selector(didSelectedSpecial:)]) {
        [_delegate didSelectedSpecial:model];
    }
}
@end

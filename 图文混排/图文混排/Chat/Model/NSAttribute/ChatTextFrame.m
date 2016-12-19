//
//  ChatTextFrame.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatTextFrame.h"
#import "CoreTextModel.h"
#import "EmojiManage.h"

@implementation ChatTextFrame

-(ChatModel *)chatModel{
    return _textModel;
}

-(void)setTextModel:(ChatTextModel *)textModel{
    _textModel = textModel;
    
    CGFloat headSpace = HEADIMAGESPACE * 2 + HEADVIEWWH;
    
    //计算内容大小
    CGFloat w = WIDTH - headSpace * 2 - CHATIMAGESPACE - 2 * CHATTEXTVIEWSPACE;
    CGSize size = [textModel.attributedString boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    //内容---textView是气泡的子视图
    CGFloat tX = textModel.send ? CHATTEXTVIEWSPACE : CHATIMAGESPACE + CHATTEXTVIEWSPACE;
    _textViewFrame = CGRectMake(tX, CHATTEXTVIEWSPACE, size.width, size.height);
    //气泡
    CGFloat cW = size.width + (CHATIMAGESPACE + CHATTEXTVIEWSPACE * 2);
    tX = textModel.send ? WIDTH - cW - headSpace : headSpace;
    self.bubbleIVFrame = CGRectMake(tX, HEADIMAGESPACE, cW, size.height + 2 * CHATTEXTVIEWSPACE);
    self.rowHeight = CGRectGetMaxY(self.bubbleIVFrame) + HEADIMAGESPACE;
}
@end

#pragma mark - ChatTextModel
@implementation ChatTextModel : ChatModel

-(ChatMessageType)messageType{
    return ChatMessageTypeText;
}

-(void)setText:(NSString *)text{
    _text = text;
    _attributedString = [self getAttributedStringWithString:text];
    
}

#pragma mark - 1.0.4.1
- (NSAttributedString *)getAttributedStringWithString:(NSString *)text{
//这里是根据微博进行的操作 -- 根据需求自己更改
    NSString *regulaStr = [NSString stringWithFormat:@"(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))",@"%",@"%",@"%",@"%"];
    
    NSArray *patternArray = @[@"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]",@"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+",@"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#",regulaStr];
    //@"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"
    NSMutableArray *rangeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < patternArray.count; i++) {
        NSString *pattern = patternArray[i];
        NSError *error;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error) {
            [regular enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                CoreTextModel *model = [[CoreTextModel alloc] init];
                model.type = i;
                model.range = result.range;
                model.text = [text substringWithRange:result.range];
                [rangeArray addObject:model];
            }];
        }
    }
    //让range按照降序排列-从后往前替换特殊内容
    [rangeArray sortUsingComparator:^NSComparisonResult(CoreTextModel *obj1, CoreTextModel *obj2) {
        return obj1.range.location < obj2.range.location;
    }];
    
    UIFont *font = CHATMESSAGEFONT;
#pragma maark - 属性设置方法会导致换行时出现问题
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSInteger i = 0; i < rangeArray.count; i++) {
        CoreTextModel *model = rangeArray[i];
        if (CoreTextType_IMAGE == model.type) {
            NSString *imageName = [EmojiManage getImageName:[text substringWithRange:model.range]];
#warning mark - 替换、拼接图片和--输入插入图片在位置上有很大不同--（搞不懂）
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:imageName];
            attachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributedString replaceCharactersInRange:model.range withAttributedString:attachmentString];
        }else if (CoreTextType_AT == model.type){
            NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor redColor]};
            //,NSFontAttributeName:font
            [attributedString addAttributes:dict range:model.range];
        }else if (CoreTextType_TOPIC == model.type){
            NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor greenColor]};
            [attributedString addAttributes:dict range:model.range];
        }else if (CoreTextType_HTTP == model.type){
            NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor blueColor],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
            [attributedString addAttributes:dict range:model.range];
        }
    }
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    
#pragma mark - 替换相应的图片之后，这里的range已经发生改变
    //保存特殊文字，显示高亮
    NSMutableArray *specialsMarkArray = [[NSMutableArray alloc] init];
    NSUInteger length = 0;
    for (NSInteger i = 1; i <= rangeArray.count; i++) {
        CoreTextModel *model = rangeArray[rangeArray.count - i];
        if (model.type == CoreTextType_IMAGE) {
            length += model.range.length - 1;
        }else{
            CoreTextModel *special = [[CoreTextModel alloc] init];
            special.text = model.text;
            special.type = model.type;
            special.range = NSMakeRange(model.range.location - length, model.range.length);
            [specialsMarkArray addObject:special];
        }
    }
    [attributedString addAttribute:SPECIALSMARK value:specialsMarkArray range:NSMakeRange(0, 1)];
    return attributedString;
}

-(void)setShowTimeLabel:(BOOL)showTimeLabel{
    [super setShowTimeLabel:showTimeLabel];
    if (showTimeLabel) {
        
    }
}
@end

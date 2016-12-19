//
//  ShowDetailViewController.m
//  图文混排
//
//  Created by yanzhen on 16/11/4.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "CoreTextModel.h"
#import "EmojiManage.h"
#import "RegexKitLite.h"
#import "FYTextView.h"

@interface ShowDetailViewController ()
@property (nonatomic, copy) NSString *detailText;
@property (strong, nonatomic) FYTextView *textView;
@property (nonatomic, strong) NSAttributedString *attributedString;
@end

@implementation ShowDetailViewController

-(instancetype)initWithDetailText:(NSString *)detailText{
    self = [super init];
    if (self) {
        _detailText = detailText;
    }
    return self;
}

- (instancetype)initWithAttributedText:(NSAttributedString *)detailText{
    self = [super init];
    if (self) {
        NSLog(@"%@",detailText);
        _attributedString = detailText;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = rightItem;
#warning mark - 仅做展示，不可编辑
    _textView = [[FYTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 0)];
    _textView.selectable = NO;
    _textView.backgroundColor = [UIColor grayColor];
    self.textView.attributedText = [self getAttributedStringWithString:_detailText];
    [self.view addSubview:_textView];
//    self.textView.attributedText = [self attributedStringWithString:_detailText];

}

#pragma mark - 方式一
- (NSAttributedString *)getAttributedStringWithString:(NSString *)text{
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
                [rangeArray addObject:model];
            }];
        }
    }
    //让range按照降序排列-从后往前替换特殊内容
    [rangeArray sortUsingComparator:^NSComparisonResult(CoreTextModel *obj1, CoreTextModel *obj2) {
        return obj1.range.location < obj2.range.location;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:17.0];
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
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(self.view.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _textView.height = size.height;
    return attributedString;
}

- (void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 方式二
- (NSAttributedString *)attributedStringWithString:(NSString *)text{
    
    NSString *imageStr = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSString *atStr = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    NSString *topicStr = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    NSString *urlStr = [NSString stringWithFormat:@"(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))",@"%",@"%",@"%",@"%"];
    NSArray *patternArray = @[@"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]",@"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+",@"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#",urlStr];
    
    NSMutableArray *rangeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < patternArray.count; i++) {
        NSString *pattern = patternArray[i];
        NSError *error;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error) {
            [regular enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                CoreTextModel *model = [[CoreTextModel alloc] init];
                model.type = i;
                model.text = [text substringWithRange:result.range];
                model.range = result.range;
                [rangeArray addObject:model];
            }];
        }
    }
    
    //纯文字的范围
    NSString *patterns = [NSString stringWithFormat:@"%@|%@|%@|%@", imageStr, atStr, topicStr, urlStr];
    [text enumerateStringsSeparatedByRegex:patterns usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        CoreTextModel *model = [[CoreTextModel alloc] init];
        model.type = CoreTextType_TEXT;
        model.text = *capturedStrings;
        model.range = *capturedRanges;
        [rangeArray addObject:model];
    }];
    
    [rangeArray sortUsingComparator:^NSComparisonResult(CoreTextModel *obj1, CoreTextModel *obj2) {
        return obj1.range.location > obj2.range.location;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:17.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
//保存特殊文字，显示高亮
    NSMutableArray *specialsMarkArray = [[NSMutableArray alloc] init];
    [rangeArray enumerateObjectsUsingBlock:^(CoreTextModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        NSLog(@"TTTT:%@",NSStringFromRange(obj.range));
        NSAttributedString *string;
        if (CoreTextType_TEXT == obj.type) {
            string = [[NSAttributedString alloc] initWithString:obj.text];
        }else if (CoreTextType_IMAGE == obj.type) {
            NSString *imageName = [EmojiManage getImageName:obj.text];
#warning mark - 替换、拼接图片和--输入插入图片在位置上有很大不同--（搞不懂）
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:imageName];
            attachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
            string = [NSAttributedString attributedStringWithAttachment:attachment];
        }else{
            if (CoreTextType_AT == obj.type){
                string = [[NSAttributedString alloc] initWithString:obj.text attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
            }else if (CoreTextType_TOPIC == obj.type){
                string = [[NSAttributedString alloc] initWithString:obj.text attributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
            }else if (CoreTextType_HTTP == obj.type){
                string = [[NSAttributedString alloc] initWithString:obj.text attributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
            }
            CoreTextModel *model = [[CoreTextModel alloc] init];
            model.text = obj.text;
            model.type = obj.type;
            model.range = NSMakeRange(attributedString.length, obj.range.length);
            [specialsMarkArray addObject:model];
        }
        [attributedString appendAttributedString:string];
        
    }];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:SPECIALSMARK value:specialsMarkArray range:NSMakeRange(0, 1)];
    
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(self.view.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _textView.height = size.height;
    return attributedString;
    
}


@end

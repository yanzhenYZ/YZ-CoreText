//
//  TextAndImage1.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "TextAndImage1.h"

@implementation TextAndImage1

+ (NSAttributedString *)onlyTextAndImage:(CGFloat)fontSize{
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //1
    NSDictionary *attrs = @{NSFontAttributeName: font};
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"这仅仅是一-------------====个测试" attributes:attrs];
    //2
    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:@"https://www.baidu.com" attributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName:[UIColor blueColor],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [string1 appendAttributedString:string2];
    //3
#warning mark - 附件的bounds设置，想x,y是固定的值
#warning mark - 插入或者是添加一个附件必须重新设置NSAttributedString的属性-font和光标的位置
    CGFloat attachmentWH = font.lineHeight;
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"d_aini"];
    attachment.bounds = CGRectMake(0, -4, attachmentWH, attachmentWH);
    NSAttributedString *string3 = [NSAttributedString attributedStringWithAttachment:attachment];
    [string1 appendAttributedString:string3];
    //4
    NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
    attachment1.image = [UIImage imageNamed:@"d_chanzui"];
    attachment1.bounds = CGRectMake(0, -4, attachmentWH, attachmentWH);
    NSAttributedString *string4 = [NSAttributedString attributedStringWithAttachment:attachment1];
    [string1 appendAttributedString:string4];
    //5
    NSTextAttachment *attachment2 = [[NSTextAttachment alloc] init];
    attachment2.image = [UIImage imageNamed:@"d_bishi"];
    attachment2.bounds = CGRectMake(0, -4, attachmentWH, attachmentWH);
    NSAttributedString *string5 = [NSAttributedString attributedStringWithAttachment:attachment2];
    [string1 appendAttributedString:string5];
    //6
    NSAttributedString *string6 = [[NSAttributedString alloc] initWithString:@"#This is just a test#" attributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName:[UIColor blueColor]}];
    [string1 appendAttributedString:string6];
    return string1;
}

@end

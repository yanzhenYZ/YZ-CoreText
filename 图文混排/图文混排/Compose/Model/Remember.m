//
//  Remember.m
//  图文混排
//
//  Created by yanzhen on 16/11/4.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "Remember.h"

@implementation Remember

- (void)test1{
//    NSMutableArray *rangeArray = [[NSMutableArray alloc] init];
//    // 表情的规则
//    NSString *pattern1 = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
//    NSError *error1;
//    NSRegularExpression *regular1 = [NSRegularExpression regularExpressionWithPattern:pattern1 options:NSRegularExpressionCaseInsensitive error:&error1];
//    if (!error1) {
//        NSArray *matches1 = [regular1 matchesInString:text options:0 range:NSMakeRange(0, text.length)];
//        for (NSTextCheckingResult *result in matches1) {
//            CoreTextModel *model = [[CoreTextModel alloc] init];
//            model.type = CoreTextType_IMAGE;
//            model.range = result.range;
//            [rangeArray addObject:model];
//            //            NSLog(@"TTTT1:%@",NSStringFromRange(result.range));
//        }
//    }
//    
//    // @的规则
//    NSString *pattern2 = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
//    NSError *error2;
//    NSRegularExpression *regular2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:NSRegularExpressionCaseInsensitive error:&error2];
//    if (!error2) {
//        NSArray *matches2 = [regular2 matchesInString:text options:0 range:NSMakeRange(0, text.length)];
//        for (NSTextCheckingResult *result in matches2) {
//            CoreTextModel *model = [[CoreTextModel alloc] init];
//            model.type = CoreTextType_AT;
//            model.range = result.range;
//            [rangeArray addObject:model];
//            //            NSLog(@"TTTT2:%@",NSStringFromRange(result.range));
//        }
//    }
//    // #话题#的规则
//    NSString *pattern3 = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
//    NSError *error3;
//    NSRegularExpression *regular3 = [NSRegularExpression regularExpressionWithPattern:pattern3 options:NSRegularExpressionCaseInsensitive error:&error3];
//    if (!error3) {
//        NSArray *matches3 = [regular3 matchesInString:text options:0 range:NSMakeRange(0, text.length)];
//        for (NSTextCheckingResult *result in matches3) {
//            CoreTextModel *model = [[CoreTextModel alloc] init];
//            model.type = CoreTextType_TOPIC;
//            model.range = result.range;
//            [rangeArray addObject:model];
//            //            NSLog(@"TTTT3:%@",NSStringFromRange(result.range));
//        }
//    }
//    
//    
//    // url链接的规则
//    NSString *pattern4 = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
//    NSError *error4;
//    NSRegularExpression *regular4 = [NSRegularExpression regularExpressionWithPattern:pattern4 options:NSRegularExpressionCaseInsensitive error:&error4];
//    if (!error4) {
//        NSArray *matches4 = [regular4 matchesInString:text options:0 range:NSMakeRange(0, text.length)];
//        for (NSTextCheckingResult *result in matches4) {
//            CoreTextModel *model = [[CoreTextModel alloc] init];
//            model.type = CoreTextType_HTTP;
//            model.range = result.range;
//            [rangeArray addObject:model];
//            //           NSLog(@"TTTT4:%@",NSStringFromRange(result.range));
//        }
//    }

}

@end

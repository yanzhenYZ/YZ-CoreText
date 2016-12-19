//
//  CoreTextModel.h
//  图文混排
//
//  Created by yanzhen on 16/11/4.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SPECIALSMARK @"SpecialsMark"

typedef NS_ENUM(NSUInteger, CoreTextType) {
    CoreTextType_IMAGE,
    CoreTextType_AT,
    CoreTextType_TOPIC,
    CoreTextType_HTTP,
    CoreTextType_TEXT
};

@interface CoreTextModel : NSObject<NSCopying>
@property (nonatomic, assign) CoreTextType type;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString *text;
@end

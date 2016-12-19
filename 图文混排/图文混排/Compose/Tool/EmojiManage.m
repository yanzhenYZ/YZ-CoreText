//
//  EmojiManage.m
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "EmojiManage.h"
#import "EmojiModel.h"

@implementation EmojiManage
static NSArray *_emojis, *_images, *_gifs;

+ (BOOL)isImageWithChs:(NSString *)chs{
    NSArray *images = [self allImages];
    NSArray *gifs = [self allGifs];
    NSMutableArray *allImages = [[NSMutableArray alloc] initWithArray:images];
    [allImages addObjectsFromArray:gifs];
    __block BOOL isImage = NO;
    [allImages enumerateObjectsUsingBlock:^(EmojiModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.chs isEqualToString:chs]) {
            isImage = YES;
            *stop = YES;
        }
    }];
    return isImage;
}

+ (BOOL)isGif:(NSString *)chs{
    __block BOOL isGif = NO;
    NSArray *gifs = [self allGifs];
    [gifs enumerateObjectsUsingBlock:^(EmojiModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.chs isEqualToString:chs]) {
            isGif = YES;
            *stop = YES;
        }
    }];
    return isGif;
}

+ (NSString *)getImageName:(NSString *)chs{
    NSArray *images = [self allImages];
    NSArray *gifs = [self allGifs];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:images];
    [array addObjectsFromArray:gifs];
    __block NSString *imageName = @"";
    [array enumerateObjectsUsingBlock:^(EmojiModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.chs isEqualToString:chs]) {
            imageName = obj.png;
            *stop = YES;
        }
    }];
    return imageName;
}

+ (NSArray *)allImages{
    if (!_images) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"image-info.plist" ofType:nil];
        NSArray *images = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in images) {
            EmojiModel *model = [[EmojiModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        _images = [[NSArray alloc] initWithArray:array];
    }
    return _images;
}

+ (NSArray *)allEmojis{
    if (!_emojis) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji-info.plist" ofType:nil];
        NSArray *emojis = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in emojis) {
            EmojiModel *model = [[EmojiModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        _emojis = [[NSArray alloc] initWithArray:array];
    }
    return _emojis;
}

+ (NSArray *)allGifs
{
    if (!_gifs) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lxh-info.plist" ofType:nil];
        NSArray *gifs = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in gifs) {
            EmojiModel *model = [[EmojiModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        _gifs = [[NSArray alloc] initWithArray:array];
    }
    return _gifs;
}
@end

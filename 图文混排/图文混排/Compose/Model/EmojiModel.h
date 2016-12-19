//
//  EmojiModel.h
//  图文混排
//
//  Created by yanzhen on 16/11/3.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiModel : NSObject
/**            文字描述                  */
@property (nonatomic, copy) NSString *chs;
/**            图片名                    */
@property (nonatomic, copy) NSString *png;
/**            emoji的16进制编码          */
@property (nonatomic, copy) NSString *code;
@end

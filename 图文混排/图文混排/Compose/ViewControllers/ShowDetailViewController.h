//
//  ShowDetailViewController.h
//  图文混排
//
//  Created by yanzhen on 16/11/4.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailViewController : UIViewController
- (instancetype)initWithDetailText:(NSString *)detailText;
- (instancetype)initWithAttributedText:(NSAttributedString *)detailText;
@end

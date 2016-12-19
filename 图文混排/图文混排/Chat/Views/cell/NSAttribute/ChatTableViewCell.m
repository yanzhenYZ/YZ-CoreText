//
//  ChatTableViewCell.m
//  图文混排
//
//  Created by yanzhen on 16/11/18.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.image = [UIImage imageNamed:@"HeadImage"];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = HEADVIEWWH / 2;
        [self.contentView addSubview:self.headImageView];
        
        self.bubbleImageView = [[UIImageView alloc] init];
        self.bubbleImageView.userInteractionEnabled = YES;
        //添加很多子视图
        self.bubbleImageView.clipsToBounds = YES;
        [self addSubview:self.bubbleImageView];
    }
    return self;
}


@end

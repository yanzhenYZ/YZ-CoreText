//
//  KeepProgammer.m
//  图文混排
//
//  Created by yanzhen on 16/11/15.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "KeepProgammer.h"
#import "ChatViewController.h"

@implementation KeepProgammer

/**
 1.0.7   CoreText
 1.0.7.1   图片占位符
 1.0.7.1.1 (不能使用空格作为占位符)
 1.0.7.1.2 空格作为占位符 占据最后一个字符计算错误
 
 1.0.7.2 加入gif
 1.0.7.2.1 gif
 */


/**
 1.0.6 gif
 1.0.6.1 gif单独存在
 */



/**
 1.0.1 tableView -- XIB动画比较生硬 ==>> 手写方式 -old- - (void)keep2
 1.0.2 tableView -- 进入时滚动到底部的问题 --
 1.0.3.1 点击emoji及删除按钮的问题 --- #import "ToolbarTextView.h"
 
 1.0.3.2 文字内容较多超出textView.frame
 ①textView内容为空--发送--按钮灰暗
 ②EmojiToolbar--发送--按钮
 { 1.0.3.2.10 -- 方式一 解决按钮状态变化
 { 1.0.3.2.20 -- 方式二
 
 ③监听textView.contentSize
   1.超出五行的时候，下面会漏出一部分---告诉用户正在输入-------1.0.3.2.1
   2.wechat当输入五行的时候，接着输入的内容就会看不到，只能手动滑动
 ④切换录制语音 -- 文字内容超过一行对frame做处理 1.0.3.2.40
 */

/**
1.0.4
1.0.4.1 -- NSAttributedString--cell
1.0.4.2 -- 避免UITextView touchEnd -- UITapGestureRecognizer 冲突
*/

/**
1.0.5
1.0.5.1 -- 发送和接收Message
1.0.5.2 -- 发图片
*/



- (void)keep2{
    /*
     //    [UIView animateWithDuration:0.25 animations:^{
     //        self.emojiKeyboard.y = self.view.height - emojiH;
     //        self.chatMoreView.y = self.view.height - moreViewH;
     //        self.toolbar.y = originY - emojiH - moreViewH - CHATTOOLBARHEIGHT;
     //        self.tableView.height = self.toolbar.y;
     ////        self.tableViewBottomConstraint.constant = self.view.height - self.toolbar.y;
     //    } completion:^(BOOL finished) {
     //        //键盘show---发生拖拽--键盘隐藏的时候拖拽状态不变-接着调用keyboardChange改变拖拽状态
     //        if (!_dragging) {
     //            //一定要在动画结束调用
     //            [self tableViewScollToBottom];
     //        }
     //
     //        if (finish) {
     //            finish();
     //        }
     //    }];

     */
}


- (void)keep1{
    //ChatViewController - updateStatus
    /*
     self.toolbar.voiceBtn.hidden = YES;
     self.toolbar.recordBtn.selected = NO;
     self.toolbar.emojiBtn.selected = NO;
     #warning mark - Keyboard
     //手动创建toolbar,直接设置y，也可以用transform方式---都可以平稳过度键盘显示和隐藏
     //XIB设置约束的方式会出现过度提前和滞后的问题
     
     //可以简化动画
     if (self.toolbar.type == CHATTOOLBARTYPE_KEYBOARD) {
     [UIView animateWithDuration:0.25 animations:^{
     self.emojiKeyboard.y = self.view.height;
     self.chatMoreView.y = self.view.height;
     self.toolbar.y = rect.origin.y - CHATTOOLBARHEIGHT;
     self.tableViewBottomConstraint.constant = self.view.height - self.toolbar.y + 10;
     }];
     }else if (self.toolbar.type == CHATTOOLBARTYPE_RECORDING) {
     self.toolbar.voiceBtn.hidden = NO;
     self.toolbar.recordBtn.selected = YES;
     [UIView animateWithDuration:0.25 animations:^{
     self.emojiKeyboard.y = self.view.height;
     self.chatMoreView.y = self.view.height;
     self.toolbar.y = self.view.height - CHATTOOLBARHEIGHT;
     self.tableViewBottomConstraint.constant = self.view.height - self.toolbar.y + 10;
     }];
     }else if (self.toolbar.type == CHATTOOLBARTYPE_EMOJI) {
     self.toolbar.emojiBtn.selected = YES;
     [UIView animateWithDuration:0.25 animations:^{
     self.emojiKeyboard.y = self.view.height - EMOJIKEYBOARDHEIGHT;
     self.chatMoreView.y = self.view.height;
     self.toolbar.y = self.view.height - EMOJIKEYBOARDHEIGHT - CHATTOOLBARHEIGHT;
     self.tableViewBottomConstraint.constant = self.view.height - self.toolbar.y + 10;
     }];
     }else if (self.toolbar.type == CHATTOOLBARTYPE_MORE) {
     [UIView animateWithDuration:0.25 animations:^{
     self.emojiKeyboard.y = self.view.height;
     self.chatMoreView.y = self.view.height - CHATMOREVIEWHEIGHT;
     self.toolbar.y = self.view.height - CHATTOOLBARHEIGHT - CHATMOREVIEWHEIGHT;
     self.tableViewBottomConstraint.constant = self.view.height - self.toolbar.y + 10;
     }];
     }else if (self.toolbar.type == CHATTOOLBARTYPE_NORMAL) {
     [UIView animateWithDuration:0.25 animations:^{
     self.emojiKeyboard.y = self.view.height;
     self.chatMoreView.y = self.view.height;
     self.toolbar.y = self.view.height - CHATTOOLBARHEIGHT;
     self.tableViewBottomConstraint.constant = self.view.height - self.toolbar.y + 10;
     }];
     }
     
     */
}

@end

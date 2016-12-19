//
//  ChatViewController.m
//  图文混排
//
//  Created by yanzhen on 16/11/2.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ChatViewController.h"
#import "EmojiKeyboard.h"
#import "EmojiSendButton.h"
#import "ChatMoreView.h"
#import "ChatTextTableViewCell.h"
#import "ChatPictureTableViewCell.h"
#import "YZWeChatPictureTableViewCell.h"
#import "ToolbarTextView.h"
#import "ChatToolbar.h"
#import "EmojiToolbar.h"
#import "EmojiModel.h"
#import "ChatFrameHeader.h"
#import "CoreTextModel.h"
#import "OLImage.h"

#pragma mark - 1.0.7 CoreText

#define Use_CoreText
#import "ChatCoreTextTableViewCell.h"
#import "ChatCoreTextFrame.h"
#import "CoreTextView.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,ChatToolbarDelegate,ChatTableViewCellDelegate,UIGestureRecognizerDelegate,ChatMoreViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ChatCoreTextTableViewCellDelegate>
@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) ChatToolbar *toolbar;
@property (nonatomic, strong) EmojiKeyboard *emojiKeyboard;
@property (nonatomic, strong) ChatMoreView *chatMoreView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSTimeInterval lastDate;
//键盘显示状态---当页面右划(内部好像会调用view endEditing)键盘会隐藏，恢复页面时键盘会弹起
@property (nonatomic, assign) BOOL viewWillDisappear;
@property (nonatomic, assign) BOOL dragging;//键盘弹起发生拖拽，键盘收起来之后--会有滚动到底部的反弹
@property (nonatomic, assign) int lineNum;//textView当前行数

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"聊天";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    _lineNum = 1;
    [self configUI];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Message.plist" ofType:nil];
    NSArray *messages = [[NSArray alloc] initWithContentsOfFile:file];

    __block NSMutableArray *array = [NSMutableArray array];
#ifdef Use_CoreText
    [messages enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatCoreTextModel *model = [[ChatCoreTextModel alloc] init];
        model.text = obj;
        model.send = arc4random_uniform(2) % 2;
        ChatCoreTextFrame*textFrame = [[ChatCoreTextFrame alloc] init];
        textFrame.textModel = model;
        [array addObject:textFrame];
    }];
#else
    [messages enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatTextModel *model = [[ChatTextModel alloc] init];
        model.text = obj;
        model.send = arc4random_uniform(2) % 2;
        ChatTextFrame *textFrame = [[ChatTextFrame alloc] init];
        textFrame.textModel = model;
        [array addObject:textFrame];
    }];
#endif
    [self.dataSource addObjectsFromArray:array];
//    [self.dataSource addObjectsFromArray:array];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _viewWillDisappear = NO;
#pragma mark - 1.0.2
    //延迟0.1秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewWillDisappear = YES;
}
#pragma mark - Action
- (void)tapTableView:(UITapGestureRecognizer *)sender {
    [self closeInputViews];
}

- (void)closeInputViews{
    if (self.toolbar.type == CHATTOOLBARTYPE_NORMAL) return;
    if ([self.toolbar.textView isFirstResponder]) {
        self.toolbar.type = CHATTOOLBARTYPE_NORMAL;
        [_toolbar.textView resignFirstResponder];
    }else if (_toolbar.type == CHATTOOLBARTYPE_RECORDING){
        return;
    }else{
        self.toolbar.type = CHATTOOLBARTYPE_NORMAL;
        [self updateStatus:CGRectZero finish:^{
            _dragging = NO;
        }];
    }
}

- (void)tableViewScollToBottom:(BOOL)animated{
    //QQ--滑动以后不做滚动到底部的操作
    //wechat--滚动到最后一条
    if (self.tableView.isTracking) return;
    
    if (self.dataSource.count > 0) {
        _lastDate = [[NSDate date] timeIntervalSince1970];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - 1.0.3.2 ②
-(void)textViewContentSizeChanged{
    [self changeTextViewContentSize:YES];
}
#pragma mark - 1.0.3.2.40
- (void)changeTextViewContentSize:(BOOL)updateFrame{
    CGSize size = self.toolbar.textView.contentSize;
    _lineNum = (int)((size.height - 10) / TextView_LineHeight);
    _lineNum = _lineNum < 1 ? 1 : _lineNum;
    _lineNum = _lineNum > 5 ? 5 : _lineNum;
    if (updateFrame) {
        CGRect rect = CGRectZero;
        if (self.toolbar.type == CHATTOOLBARTYPE_KEYBOARD) {
            rect.origin.y = self.toolbar.y + self.toolbar.height;
        }
#warning mark - 1.0.3.2
        //纯键盘输入
        //必须在textView设置contentOffset之前改变textView的高度否则会发生偏移
        self.toolbar.textView.height = CHATTOOLBARHEIGHT + (_lineNum - 1) * (TextView_LineHeight - 1) - 10;
        [self updateStatus:rect finish:nil];
    }
}

- (void)emojiSendBtnEnable{
#pragma mark - 1.0.3.2.10
//    self.emojiKeyboard.toolBar.sendBtn.enabled = self.toolbar.textView.text.length > 0;
}

#pragma mark - ChatMoreViewDelegate
-(void)chatMoreViewBtnClick:(ChatMoreViewType)type{
    if (type == ChatMoreViewImage) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:^{
            
        }];
    }else if (type == ChatMoreViewGif){
#pragma mark - 1.0.6.1
        NSArray *gifs = @[@"notEven.gif",@"google-io",@"AA.gif",@"fdgdf.gif"];
        ChatPictureFrame *frame = [[ChatPictureFrame alloc] init];
        ChatPictureModel *model = [[ChatPictureModel alloc] init];
        NSInteger index = arc4random_uniform(4);
        model.image = [OLImage imageNamed:gifs[index]];
        model.send = arc4random_uniform(2) % 2;
        frame.pictureModel = model;
        [self.dataSource addObject:frame];
        [self.dataSource removeObjectAtIndex:0];
        [self tabelViewReloadData];
    }
}

#pragma mark - 1.0.5.2
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //需要先把image写到一个路径下---
    //开始处理
    ChatPictureFrame *frame = [[ChatPictureFrame alloc] init];
    ChatPictureModel *model = [[ChatPictureModel alloc] init];
    model.image = image;
    model.send = arc4random_uniform(2) % 2;
    frame.pictureModel = model;
    [self.dataSource addObject:frame];
    [self tabelViewReloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
#pragma mark - 1.0.4.2
#pragma mark - 避免和cell的textView发生touchEnd冲突
#ifdef Use_CoreText
    if ([touch.view isKindOfClass:[CoreTextView class]]) {
        return NO;
    }
#else
    if ([touch.view isKindOfClass:[UITextView class]]) {
        return NO;
    }
#endif
    return YES;
}

#pragma mark - ChatTableViewCellDelegate
-(void)didSelectedSpecial:(CoreTextModel *)textModel{
    if (textModel.type == CoreTextType_HTTP) {
        NSURL *url = [NSURL URLWithString:textModel.text];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    NSLog(@"-----%@",textModel.text);
}

#pragma mark - ChatToolbarDelegate
-(void)toolBarButtonClick:(CHATTOOLBARTYPE)type{
    if (type == self.toolbar.type) {
        [self textViewContentSizeChanged];
        [self.toolbar.textView becomeFirstResponder];
        return;
    }
    
//toolbar在底部的时候，做录音操作的话不需要处理tableView
    if (type == CHATTOOLBARTYPE_RECORDING) {
        if (self.toolbar.type == CHATTOOLBARTYPE_NORMAL) {
            self.toolbar.voiceBtn.hidden = NO;
            self.toolbar.type = type;
            [self changeTextViewContentSize:NO];
            //对于已经拖动的tableView不做滚动到底部的操作
            _dragging = YES;
            [self updateStatus:CGRectZero finish:^{
                _dragging = NO;
            }];
#warning mark - 文字过多时需要处理textview.frame
            return;
        }
    }
    
    if (self.toolbar.type == CHATTOOLBARTYPE_KEYBOARD) {
        //键盘隐藏之后标记的状态仍然是CHATTOOLBARTYPE_KEYBOARD
        //所以这里要判断键盘是否隐藏
        if (self.toolbar.textView.isFirstResponder) {
            self.toolbar.type = type;
            [self.toolbar.textView resignFirstResponder];
            return;
        }
    }
    self.toolbar.type = type;
    [self changeTextViewContentSize:NO];
    [self updateStatus:CGRectZero finish:^{
        _dragging = NO;
    }];
}

-(void)sendMessage:(NSString *)message{
#ifdef Use_CoreText
    ChatCoreTextFrame *frame = [[ChatCoreTextFrame alloc] init];
    ChatCoreTextModel *model = [[ChatCoreTextModel alloc] init];
    model.send = arc4random_uniform(2) % 2;
    model.text = message;
    frame.textModel= model;
    [self.dataSource addObject:frame];
#else
    ChatTextFrame *frame = [[ChatTextFrame alloc] init];
    ChatTextModel *model = [[ChatTextModel alloc] init];
    model.send = arc4random_uniform(2) % 2;
    model.text = message;
    frame.textModel= model;
    [self.dataSource addObject:frame];
#endif
    [self tabelViewReloadData];
    //
    self.emojiKeyboard.toolBar.sendBtn.enabled = NO;
}

#pragma mark - 1.0.5.1
- (void)tabelViewReloadData{
    [self.tableView reloadData];
    [self tableViewScollToBottom:YES];
}

-(void)textViewTextDidChange{
    self.emojiKeyboard.toolBar.sendBtn.enabled = self.toolbar.textView.text.length > 0;
}

- (void)emojiSendBtnClick:(UIButton *)sendBtn{
    [self sendMessage:self.toolbar.textView.text];
    self.toolbar.textView.text = nil;
    
}
#pragma mark - notification
#pragma mark - 1.0.3.1
- (void)emojiDidselected:(NSNotification *)notification{
    EmojiModel *emoji = notification.userInfo[EMOJIDIDSELECTEDKEY];
    if (emoji.code) {
       [self.toolbar.textView insertText:emoji.code.emoji];
    }else if (emoji.png) {
        [self.toolbar.textView insertText:emoji.chs];
    }
    [self emojiSendBtnEnable];
}

- (void)emojiDidDelete{
    [self.toolbar.textView deleteBackward];
    [self emojiSendBtnEnable];
}


- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolbar.type = CHATTOOLBARTYPE_KEYBOARD;
//这里调用该方法避免-keyboardWasChange-出现toolbar动画的滞后问题
    [self updateStatus:rect finish:^{
        _dragging  = NO;
        [self textViewContentSizeChanged];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateStatus:rect finish:nil];
}

- (void)keyboardWasChange:(NSNotification *)notification{
    if (_dragging) {
        _dragging = NO;
        return;
    }
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateStatus:rect finish:nil];
}

- (void)updateStatus:(CGRect)rect finish:(void (^)(void))finish{
    if (_viewWillDisappear) return;
    
    self.toolbar.voiceBtn.hidden = YES;
    self.toolbar.recordBtn.selected = NO;
    self.toolbar.emojiBtn.selected = NO;
    
    CGFloat emojiH = 0;
    CGFloat moreViewH = 0;
    CGFloat originY = self.view.height;
    if (self.toolbar.type == CHATTOOLBARTYPE_KEYBOARD) {
        originY = rect.origin.y;
    }else if (self.toolbar.type == CHATTOOLBARTYPE_RECORDING) {
        _lineNum = 1;
        self.toolbar.recordBtn.selected = YES;
        self.toolbar.voiceBtn.hidden = NO;
    }else if (self.toolbar.type == CHATTOOLBARTYPE_EMOJI) {
        self.toolbar.emojiBtn.selected = YES;
        [self emojiSendBtnEnable];
        emojiH = EMOJIKEYBOARDHEIGHT;
    }else if (self.toolbar.type == CHATTOOLBARTYPE_MORE) {
        moreViewH = CHATMOREVIEWHEIGHT;
    }
    
#pragma mark - 1.0.1
    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    
    self.emojiKeyboard.y = self.view.height - emojiH;
    self.chatMoreView.y = self.view.height - moreViewH;
#pragma mark - 1.0.3.2.1
//    self.toolbar.height = CHATTOOLBARHEIGHT + (_lineNum - 1) * TextView_LineHeight;
#pragma mark - 1.0.3.2.2
    self.toolbar.height = CHATTOOLBARHEIGHT + (_lineNum - 1) * (TextView_LineHeight - 1);
    self.toolbar.y = originY - emojiH - moreViewH - self.toolbar.height;
//    self.tableView.height = self.toolbar.y;
    //避免tableView出现反弹的效果
    self.tableView.transform = CGAffineTransformMakeTranslation(0, self.toolbar.y - self.tableView.height);
    [UIView commitAnimations];
    if (!_dragging) {
        [self tableViewScollToBottom:NO];
    }
    if (finish) {
        finish();
    }
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatFrame *frame = self.dataSource[indexPath.row];
#ifdef Use_CoreText
    if ([frame isKindOfClass:[ChatCoreTextFrame class]]) {
        ChatCoreTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextTableViewCell"];
        if (!cell) {
            cell = [[ChatCoreTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatTextTableViewCell"];
                cell.delegate = self;
        }
        cell.textFrame = _dataSource[indexPath.row];
        return cell;
    }
#else
    if ([frame isKindOfClass:[ChatTextFrame class]]) {
        ChatTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextTableViewCell"];
        if (!cell) {
            cell = [[ChatTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatTextTableViewCell"];
                cell.delegate = self;
            //        NSLog(@"TTTT:%s",__func__);
        }
        cell.textFrame = _dataSource[indexPath.row];
        return cell;
    }
    
#endif
    else if ([frame isKindOfClass:[ChatPictureFrame class]]) {
//        ChatPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatPictureTableViewCell"];
//        if (!cell) {
//            cell = [[ChatPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatPictureTableViewCell"];
//        }
#pragma mark - 类似微信--图片可以占据全部气泡
        YZWeChatPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YZWeChatPictureTableViewCell"];
        if (!cell) {
            cell = [[YZWeChatPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YZWeChatPictureTableViewCell"];
        }
        
        
        
        cell.pictureFrame = _dataSource[indexPath.row];
        return cell;
    }
    return nil;
}
#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.toolbar.type != CHATTOOLBARTYPE_NORMAL && self.toolbar.type != CHATTOOLBARTYPE_RECORDING) {
        //录制语音--不记录拖拽
        self.dragging = YES;
        [self closeInputViews];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#warning mark - cell的高度 需要提前算好不然会出现复用的问题
    ChatTextFrame *frame = _dataSource[indexPath.row];
    return frame.rowHeight;
}
#pragma mark - last
- (void)configUI{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - CHATTOOLBARHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView:)];
    tap.delegate = self;
    [tableView addGestureRecognizer:tap];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    ChatToolbar *toolbar = [[ChatToolbar alloc] initWithFrame:CGRectMake(0, HEIGHT - CHATTOOLBARHEIGHT, WIDTH, CHATTOOLBARHEIGHT)];
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    _toolbar = toolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiDidselected:) name:EMOJIPAGEVIEWDIDSELECTEDEMOJI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiDidDelete) name:EMOJIPAGEVIEWDIDDELETEEMOJI object:nil];
}

-(ChatMoreView *)chatMoreView{
    if (!_chatMoreView) {
        _chatMoreView = [[ChatMoreView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, CHATMOREVIEWHEIGHT)];
        _chatMoreView.delegate = self;
        [self.view addSubview:_chatMoreView];
    }
    return _chatMoreView;
}

-(EmojiKeyboard *)emojiKeyboard{
    if (!_emojiKeyboard) {
        _emojiKeyboard = [[EmojiKeyboard alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, EMOJIKEYBOARDHEIGHT)];
        _emojiKeyboard.toolBar.sendBtn.hidden = NO;
        [_emojiKeyboard.toolBar.sendBtn addTarget:self action:@selector(emojiSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_emojiKeyboard];
    }
    return _emojiKeyboard;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

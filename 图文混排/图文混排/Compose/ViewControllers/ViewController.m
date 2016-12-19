//
//  ViewController.m
//  图文混排
//
//  Created by yanzhen on 16/11/1.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ViewController.h"
#import "ShowDetailViewController.h"
#import "ComposeTextView.h"
#import "ComposeToolbar.h"
#import "TextAndImage1.h"
#import "EmojiKeyboard.h"
#import "EmojiModel.h"
#import "CoreTextModel.h"
#import "EmojiManage.h"

@interface ViewController ()<ComposeToolbarDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet ComposeTextView *textView;

@property (nonatomic, strong) ComposeToolbar *toolbar;
@property (nonatomic, strong) EmojiKeyboard *emojiKeyboard;

@property (nonatomic, assign) BOOL switchingKeybaord;

@end

@implementation ViewController

-(EmojiKeyboard *)emojiKeyboard{
    if (!_emojiKeyboard) {
        _emojiKeyboard = [[EmojiKeyboard alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 216)];
    }
    return _emojiKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"发布";
//    _textView.attributedText = [TextAndImage1 onlyTextAndImage:_textView.font.pointSize];
    _textView.normalFont = _textView.font;
//    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.attributedText = [TextAndImage1 onlyTextAndImage:17.0];
    
    [_textView becomeFirstResponder];
    [self textDidChange];
    
    _toolbar = [[ComposeToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    _toolbar.delegate = self;
    [self.view addSubview:_toolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiDidselected:) name:EMOJIPAGEVIEWDIDSELECTEDEMOJI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiDidDelete) name:EMOJIPAGEVIEWDIDDELETEEMOJI object:nil];
}


#pragma mark - action
- (IBAction)sendText:(UIBarButtonItem *)sender {
//    [self regular:@"我的[爱你]😞[发红包]@2158：[哈哈]#4580#[哈哈]www.baidu.com"];
    //@"我的[爱你]😞[发红包]-YES-@2158:NO[哈哈]NO#4580#哈哈[哈哈]哈哈www.baidu.com"
#warning mark - 随意内容掺杂会导致换行问题
    //😞zzzzhhzzzzzz[发红包]z--z@2158:NO[哈哈]NO#4580#N[哈哈]HHHHhhH-https://www.baidu.com
    ShowDetailViewController *vc = [[ShowDetailViewController alloc] initWithDetailText:@"😞我的世界你不懂[发红包]真的吗@2158:NO[哈哈]你#你不懂#N[哈哈]HHHHhhH-https://www.baidu.com"];
//    ShowDetailViewController *vc = [[ShowDetailViewController alloc] initWithDetailText:[self.textView plainText]];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:^{
        [self.textView resignFirstResponder];
//        self.textView.text = nil;
        [self textDidChange];
    }];
}

#pragma mark - ComposeToolbarDelegate
-(void)composeToolbarDidClick:(ComposeToolbarButtonType)toolbarButtonType{
    if (ComposeToolbarButtonType_EMOJ == toolbarButtonType) {
        if (!self.textView.inputView) {
            self.textView.inputView = self.emojiKeyboard;
            self.toolbar.showKeyBoardImage = YES;
        }else{
            self.textView.inputView = nil;
            self.toolbar.showKeyBoardImage = NO;
        }
        
#warning mark - 此处需要先关掉键盘然后弹出inputView在键盘切换的时候不处理toolbar的frame
        self.switchingKeybaord = YES;
        [self.textView resignFirstResponder];
        self.switchingKeybaord = NO;
        
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - notification
- (void)keyBoardFrameChange:(NSNotification *)notification{
    //键盘和emoji正在切换的时候，不处理toolbar的frame
    if (self.switchingKeybaord) return;
    NSDictionary *userInfo = notification.userInfo;
    
    //第三方键盘这里返回值时0(不懂苹果为什么这么设计？？？)，建议0.25
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        if (keyboardFrame.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            self.toolbar.y = keyboardFrame.origin.y - self.toolbar.height;
        }
    }];
}

- (void)textDidChange{
     self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)emojiDidselected:(NSNotification *)notification{
    EmojiModel *emoji = notification.userInfo[EMOJIDIDSELECTEDKEY];
    [self.textView insertEmoji:emoji];
    [self textDidChange];
}

- (void)emojiDidDelete{
    [self.textView deleteBackward];
    [self textDidChange];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

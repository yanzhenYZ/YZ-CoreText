//
//  GeneralMacro.h
//
//  Created by yanzhen.
//

#ifndef GeneralMacro_h
#define GeneralMacro_h

#define SYSVERSION ([[UIDevice currentDevice].systemVersion floatValue])
#define ISIPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define DOCUMENT NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define FYColor(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1]
//更改国际化寻找资源的路径
#define YZLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"YZSource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]

#define EMOJIDIDSELECTEDKEY @"EmojiDidselectedKey"
#define EMOJIPAGEVIEWDIDSELECTEDEMOJI @"EmojiPageViewDidselectedEmoji"
#define EMOJIPAGEVIEWDIDDELETEEMOJI @"EmojiPageViewDidDeleteEmoji"

//chat
#define CHATMESSAGEFONT [UIFont systemFontOfSize:17.0]
#define HEADVIEWWH 40.0
//头像边距
#define HEADIMAGESPACE 10.0
//图片突出部分
#define CHATIMAGESPACE 6.0
#define CHATTEXTVIEWSPACE 10.0

#define CHATTOOLBARHEIGHT 44.0

#define EMOJIKEYBOARDHEIGHT 216.0
#define CHATMOREVIEWHEIGHT 216.0

#endif /* GeneralMacro_h */

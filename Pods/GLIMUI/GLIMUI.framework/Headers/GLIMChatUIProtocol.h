//
//  GLIMChatUIProtocol.h
//  GLIMUI
//
//  Created by 六度 on 2017/4/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMChatUIProtocol_h
#define GLIMChatUIProtocol_h


#endif /* GLIMChatUIProtocol_h */

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>

@class GLIMRecentChatCell;
@class GLIMRecentChatsListController;
@protocol GLIMChatUIProtocol <NSObject>

@optional
//用于cell点击事件传递
- (void)didClickCell:(GLIMRecentChatCell *)cell
    inChatController:(UIViewController *)chatController;

//是否响应Chat
- (BOOL)responseToChat:(GLIMChat *)chat;

//基类默认实现 根据self.configName直接生成 子类可重载
- (GLIMRecentChatCell *)cellForChat:(GLIMChat *)chat;

@end

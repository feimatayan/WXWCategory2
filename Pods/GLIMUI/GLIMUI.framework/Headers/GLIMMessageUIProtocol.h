//
//  GLIMMessageUIProtocol.h
//  Pods
//
//  Created by 六度 on 2017/3/31.
//
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMChatBaseViewController.h"

@class GLIMMessageCell;

@protocol GLIMMessageUIProtocol <NSObject>

@optional

/**
 处理聊天页面消息Cell点击事件

 @param cell 消息Cell
 @param chatController 聊天页面对象
 */
- (void)didClickCell:(GLIMMessageCell *)cell
    inChatController:(GLIMChatBaseViewController *)chatController;

//界面消失时会调用config的该方法

/**
 指定聊天页面消失时的处理逻辑

 @param chatController 聊天页面对象
 */
- (void)willDisappearWithChatController:(GLIMChatBaseViewController *)chatController;

/**
 判断是否能处理指定消息

 @param message 指定消息
 @return YES：config能处理对应的Cell
 */
- (BOOL)responseToMessage:(GLIMMessage *)message;

//基类默认实现 根据self.configName直接生成 子类可重载

/**
 为指定的消息生成消息Cell

 @param message 指定消息对象
 @return 返回消息Cell（根据self.configName生成）
 */
- (GLIMMessageCell *)cellForMessage:(GLIMMessage *)message;

@end

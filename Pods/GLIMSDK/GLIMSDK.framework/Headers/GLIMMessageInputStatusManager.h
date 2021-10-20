//
//  GLIMMessageInputStatusManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/8/9.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 消息输入状态请求
 */
@interface GLIMMessageInputStatusManager : NSObject

+ (instancetype)sharedManager;

/**
 发送正在输入文本输入消息

 @param chatID 聊天对象的uid
 @param completion 请求回调函数
 */
- (void)sendInputStartWithChatID:(NSString *)chatID completion:(void (^)(id result))completion;

/**
 发送结束文本输入消息
 
 @param chatID 聊天对象的uid
 @param completion 请求回调函数
 */
- (void)sendInputEndWithChatID:(NSString *)chatID completion:(void (^)(id result))completion;

/**
 发送正在输入语音输入消息
 
 @param chatID 聊天对象的uid
 @param completion 请求回调函数
 */
- (void)sendAudioInputStartWithChatID:(NSString *)chatID completion:(void (^)(id result))completion;

/**
 发送结束语音输入消息
 
 @param chatID 聊天对象的uid
 @param completion 请求回调函数
 */
- (void)sendAudioInputEndWithChatID:(NSString *)chatID completion:(void (^)(id result))completion;

@end

//
//  GLIMGroupMessageManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/3/9.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMGroupMessageManager : NSObject

+ (instancetype)sharedInstance;

/// 发送群消息

/// 接收群消息

/// 加载群消息

/**
 加载群消息

 @param groupID 群ID
 @param lastMsgID 上一次请求的消息ID
 @param limit 每次请求的消息个数
 @param completion 回调函数
 */
- (void)loadGroupMessage:(NSString *)groupID
               lastMsgID:(NSString *)lastMsgID
                   limit:(NSInteger)limit
              completion:(void (^)(NSArray *))completion;

/**
 加载群消息

 @param groupID groupID 群ID
 @param lastMsgID 上一次请求的消息ID
 @param limit 每次请求的消息个数
 @param direction 拉取方向 0向上 1向下
 @param completion 回调函数
 */
- (void)loadGroupMessage:(NSString *)groupID
               lastMsgID:(NSString *)lastMsgID
                   limit:(NSInteger)limit
               direction:(NSInteger)direction
              completion:(void (^)(NSArray *))completion;

/**
 加载直播群群消息
 
 @param groupID 群ID
 @param lastMsgID 上一次请求的消息ID
 @param limit 每次请求的消息个数
 @param completion 回调函数
 */
- (void)loadGroupLiveMessage:(NSString *)groupID
                   lastMsgID:(NSString *)lastMsgID
                       limit:(NSInteger)limit
                  completion:(void (^)(NSArray *))completion;

/**
 撤回群消息
 
 @param groupID 群ID
 @param server_msgid 撤回消息的server_msgid
 @param completion 回调函数
 */
- (void)withdrawGroupMessage:(NSString *)groupID
               server_msgid:(NSString *)server_msgid
              completion:(void (^)(NSDictionary *))completion;




/**
  删除群消息

 @param groupID 群ID
 @param server_msgid 撤回消息的server_msgid
 @param reason 删除理由
 @param completion 回调函数
 */
- (void)deleteGroupMessage:(NSString *)groupID
              server_msgid:(NSString *)server_msgid
                    reason:(NSString *)reason
                completion:(void (^)(NSDictionary *))completion;




/**
 清空群聊未读消息

 @param groupID 群ID
 @param completion 回调函数
 */
- (void)clearGroupUnread:(NSString *)groupID completion:(void (^)(id))completion;

@end

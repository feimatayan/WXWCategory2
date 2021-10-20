//
//  GLIMSystemMessageContent.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/10/19.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>

/// 系统消息类型
typedef NS_ENUM(NSInteger, GLIMSystemMessageContentType) {
    GLIMSystemMessageContentNormal = 0,             // 普通的系统消息
    GLIMSystemMessageContentRisk = 100,             // 风控提示
    GLIMUIMessageContentWithdraw = 103,             // 撤回消息——用于群聊
    GLIMUIMessageContentPersonalWithdraw = 104,     // 撤回消息——用于单聊
    GLIMUIMessageContentDeleteSystemMessage = 105,     // 撤回消息——用于单聊
};

/**
 系统消息内容
 */
@interface GLIMSystemMessageContent : GLIMMessageContent

/// 系统消息类型
@property (nonatomic, assign) GLIMSystemMessageContentType systemContentType;

/// 系统消息支持跳转H5
/// H5链接
@property (nonatomic, strong) NSString *jumpUrl;
/// H5显示标题
@property (nonatomic, strong) NSString *jumpName;

/// 撤回的文本内容
@property (nonatomic, copy) NSString *msgData;

/**
 根据类型（消息类型或跳转类型）检查是否支持撤回

 @param type 消息类型
 @return YES：支持 NO：不支持
 */
+ (BOOL)isWithdrawMessageWithType:(NSInteger)type;


/**
 根据类型（消息类型或跳转类型）检查是否支持删除
 
 @param type 消息类型
 @return YES：支持 NO：不支持
 */
+ (BOOL)isDeleteSystemMessageWithType:(NSInteger)type;

@end

//
//  GLIMChatViewBusinessManager.h
//  GLIMUI
//
//  Created by huangbiao on 2019/5/7.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLIMChatViewBusinessDelegate <NSObject>

@optional
/**
 处理具体联系人的业务事件

 @param chatID 具体联系人
 @param dictionary 业务数据
 */
- (void)handleBusinessDataWithChat:(NSString *)chatID
                     andDictionary:(NSDictionary *)dictionary;

/**
 是否支持处理业务数据

 @param dictionary 业务数据
 @return YES 支持处理，NO 不支持处理
 */
- (BOOL)supportBusinessDataWithDictionary:(NSDictionary *)dictionary;

@end

/**
 聊天页面业务管理
 */
@interface GLIMChatViewBusinessManager : NSObject

/// 为简单处理，先暂时定义为单个delegate，如果需要多个则定义为数组，参考GLIMMessageUIConfig
@property (nonatomic, weak) id<GLIMChatViewBusinessDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)handleBusinessDataWithChat:(NSString *)chatID
                     andDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

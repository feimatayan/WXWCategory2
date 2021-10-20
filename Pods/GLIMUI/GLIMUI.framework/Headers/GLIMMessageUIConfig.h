//
//  GLIMMessageUIConfig.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMMessageUIProtocol.h"

#define NOT_KNOW_MESSAFE_TYPE           12344321
#define TIME_STAMP_MESSAFE_TYPE         121212

typedef NS_ENUM(NSUInteger, GLIMMessageConfigPriority) {
    /// 普通消息优先级（适用于一般消息）
    GLIMMessageConfigPriorityLow = 0,           // SDK 内部Config优先级
    GLIMMessageConfigPriorityNormal = 100,       // SDK 扩展Config优先级
    GLIMMessageConfigPriorityHigh = 200,        // App 扩展Config优先级
    
    /// 普通文本消息优先级 （文本消息分为普通文本消息与商品/订单文本消息，所以需要区分优先级）
    GLIMTextMessageConfigPriorityLow = 0,       // SDK 内部文本config优先级
    GLIMTextMessageConfigPriorityNormal = 10,   // SDK 扩展文本config优先级
    GLIMTextMessageConfigPriorityHigh = 20,     // App 扩展文本config优先级
    
    /// 系统消息优先级（系统消息优先于普通消息处理）
    GLIMSystemMessageConfigPriorityLow = 1000,  // SDK 内部config优先级
    GLIMSystemMessageConfigPriorityNormal = 1100,// SDK 扩展config优先级
    GLIMSystemMessageConfigPriorityHigh = 1200, // App扩展config优先级
};


/*
 负责关联messageType 到对应的cell
 负责处理接收到的 UI发出的事件 并抛出
 如点击图片 点击语音等
 */
@interface GLIMMessageUIConfig : NSObject <GLIMMessageUIProtocol>

/// 配置名称，对应消息Cell的类名
@property (nonatomic,strong) NSString * configName;
/// 配置的优先级，高优先级的config优先解析
@property (nonatomic,assign) GLIMMessageConfigPriority priority;

/// 类方法，生成config
+ (instancetype)messageConfig;

/// 根据message 获取cell的标识
- (NSString *)cellSignForMessage:(GLIMMessage *)message;

@end

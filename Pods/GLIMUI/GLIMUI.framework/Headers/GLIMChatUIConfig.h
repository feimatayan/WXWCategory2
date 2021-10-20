//
//  GLIMChatUIConfig.h
//  GLIMUI
//
//  Created by 六度 on 2017/4/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMChatUIProtocol.h"
#import "GLIMRecentChatCell.h"

typedef NS_ENUM(NSUInteger, GLIMChatConfigPriority) {
    GLIMChatConfigPriorityLow = 0,      // SDK 内部Config
    GLIMChatConfigPriorityNormal = 10,  // SDK 扩展Config
    GLIMChatConfigPriorityHigh = 100,   // App 扩展Config
};

/**
 Config类，负责根据Chat对象获取相应的Cell并处理Cell的点击事件
 */
@interface GLIMChatUIConfig : NSObject <GLIMChatUIProtocol>

/// 配置名称，即Cell的名称
@property (nonatomic, strong) NSString *configName;
/// UIConfig的优先级，相同逻辑的config，高优先级的会覆盖低优先级
@property (nonatomic, assign) GLIMChatConfigPriority priority;

/**
 根据chat生成对象的cell标识

 @param chat chat对象
 @return cell标识
 */
- (NSString *)cellSignForChat:(GLIMChat *)chat;

@end

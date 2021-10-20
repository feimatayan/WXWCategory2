//
//  GLIMRecentChatCellFactory.h
//  GLIMUI
//
//  Created by 六度 on 2017/4/24.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMRecentChatCell.h"
#import "GLIMChatUIConfig.h"
@interface GLIMRecentChatCellFactory : NSObject

+ (GLIMRecentChatCellFactory *)shareFactory;


/**
 支持新的Cell配置

 @param config 新Cell配置
 */
- (void)addConfig:(GLIMChatUIConfig *)config;


/**
 根据chat数据生成对象Cell

 @param chat chat对象
 @return Cell
 */
- (GLIMRecentChatCell *)newCellForChat:(GLIMChat *)chat;

- (GLIMChatUIConfig *)configForChat:(GLIMChat *)chat;

- (void)reset;

@end

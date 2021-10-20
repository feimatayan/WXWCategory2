//
//  GLIMMessageContentParser.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/3/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GLIMMessageContent;
@class GLIMMessage;


@protocol GLIMMessageContentParser <NSObject>

@required

- (GLIMMessageContent*)bulidContentForMessage:(GLIMMessage*)message;

@end


/**
 默认的消息类型解析对象
 根据消息的类型生成对应的messageContent对象
 解析顺序：
 1. 按本类提供的方法解析消息
 2. 按内部消息解析器进行解析
 */
@interface GLIMDefaultMessageContentParser : NSObject <GLIMMessageContentParser>

/// 内部的消息解析器
@property (nonatomic, strong) GLIMDefaultMessageContentParser *innerParser;

@end

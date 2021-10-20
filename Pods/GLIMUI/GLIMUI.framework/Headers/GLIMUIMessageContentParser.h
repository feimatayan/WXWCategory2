//
//  GLIMUIMessageContentParser.h
//  GLIMUI
//
//  Created by huangbiao on 2018/8/8.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>

/// GLIMUI内部扩展的conentType
typedef NS_ENUM(NSInteger, GLIMUIMessageContentType) {
    GLIMUIMessageContentAutoReply = 1001,     // 自动回复
};

@interface GLIMUIMessageContentParser : GLIMDefaultMessageContentParser

@end

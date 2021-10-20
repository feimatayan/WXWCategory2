//
//  GLIMOrderAutoReplyData.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/6/1.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GLIMOrderAutoReplyType) {
    GLIMOrderAutoReplyNone = 0, //
    GLIMOrderAutoReplyNew = 1,  // 首单客户
    GLIMOrderAutoReplyOld = 2,  // 回头客户
};

@interface GLIMOrderAutoReplyData : NSObject

/// 自动回复类型
@property (nonatomic, assign) GLIMOrderAutoReplyType replyType;
/// 自动回复内容
@property (nonatomic, copy) NSString *replyContent;
/// 自动回复开关状态：0 默认关闭，1-开启
@property (nonatomic, assign) NSInteger changeStatus;

- (void)parseFieldsFromDict:(NSDictionary *)dictionary;

@end

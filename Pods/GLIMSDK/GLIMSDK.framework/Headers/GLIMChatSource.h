//
//  GLIMChatSource.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/18.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMBaseObject.h"

typedef NS_ENUM(NSInteger, GLIMChatSourceType)
{
    GLIMChatSourceNone = 0,
    GLIMChatSourceOrder = 1,    // 订单
    GLIMChatSourceGood = 2,     // 商品
    GLIMChatSourceWttOrder = 3, // 上车团订单
    GLIMChatSourceWttGroupActivities = 4,  // 上车团团活动
};


@interface GLIMChatSource : NSObject

/// 消息来源类型，商品或订单     //1订单 2商品
@property (nonatomic, assign) GLIMChatSourceType chatSourceType;

/// 消息来源标识，商品或订单ID
@property (nonatomic, strong) NSString * chatSourceID;


/// sourc需要显示的时间时间——如订单的下单时间
@property (nonatomic, strong) NSString * showTime;
// source图片
@property (nonatomic, strong) NSString * imageUrl;
// source标题
@property (nonatomic, strong) NSString * title;
// source描述
@property (nonatomic, strong) NSString * descriptionStr;
// source状态
@property (nonatomic, strong) NSString * status;
// source链接
@property (nonatomic, strong) NSString * linkUrl;

/**
 生成chatSource对象

 @param dictionary info字典
 @param type chatSource类型
 @return chatSource对象
 */
+ (instancetype)chatSourceWithDictionary:(NSDictionary *)dictionary
                                 andType:(GLIMChatSourceType)type;

@end

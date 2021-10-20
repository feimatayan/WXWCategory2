//
//  GLSelectTabBarData.h
//  GLUIKit_Trunk
//
//  Created by smallsao on 2017/4/5.
//  Copyright © 2017年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 按钮红点类型

 - GLTabBarUnReadTypePoint: 红点
 - GLTabBarUnReadTypeNum: 数字
 */
typedef NS_ENUM (NSInteger, GLTabBarUnReadType) {
    GLTabBarUnReadTypePoint = 0,
    GLTabBarUnReadTypeNum = 1
};

/**
 导航条数据结构
 */
@interface GLSelectTabBarData : NSObject

/// id
@property (nonatomic, strong) NSString *tbId;

/// 标题
@property (nonatomic, strong) NSString *tbTitle;

/// index
@property (nonatomic, assign) NSUInteger tbIndex;

/// value
@property (nonatomic, strong) NSString *tbValue;

/// unreadNum
@property (nonatomic, assign) NSUInteger tbUnreadNum;

@end

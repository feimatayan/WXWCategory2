//
//  GLIMCustomerServiceData.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/10/16.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 客服列表数据
 */
@interface GLIMCustomerServiceData : NSObject

/// im系统的uid
@property (nonatomic, strong) NSString *uid;
/// 子客服的userID
@property (nonatomic, strong) NSString *userID;
/// 子客服的名称
@property (nonatomic, strong) NSString *userName;
/// 子客服的头像
@property (nonatomic, strong) NSString *userAvatar;
/// 在线状态：1-在线，2-离线
@property (nonatomic, assign) NSInteger onlineState;
/// 服务状态：1-正常状态，2-挂起状态， 3-忙碌状态，
@property (nonatomic, assign) NSInteger serviceState;


@property (nonatomic, strong) NSString *shopName;

+ (instancetype)customerServiceDataWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)customerNewServiceDataWithDictionary:(NSDictionary *)dictionary;
/// 测试数据
+ (instancetype)randomCustomerServiceData;

@end

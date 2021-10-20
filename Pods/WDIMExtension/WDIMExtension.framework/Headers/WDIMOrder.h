//
//  WDIMOrder.h
//  WDIMExtension
//
//  Created by huangbiao on 2017/3/25.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>

/**
 订单对象，用于与App交互
 除了orderID必须有值外，其他参数均不保证有值
 */
@interface WDIMOrder : GLIMExtensionEntity

/// 订单ID（不能为空）
@property (nonatomic, strong) NSString *orderID;
/// 订单地址（可能为空）
@property (nonatomic, strong) NSString *orderUrl;
/// 订单图片地址（可能为空）
@property (nonatomic, strong) NSString *orderImageUrl;
/// 订单名称（可能为空）
@property (nonatomic, strong) NSString *orderName;
/// 订单价格（可能为空）
@property (nonatomic, strong) NSString *orderPrice;
/// 订单状态（可能为空）
@property (nonatomic, assign) NSInteger orderStatus;

@end

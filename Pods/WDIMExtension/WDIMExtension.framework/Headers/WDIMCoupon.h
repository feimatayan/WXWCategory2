//
//  WDIMCoupon.h
//  WDIMExtension
//
//  Created by huangbiao on 2017/3/25.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>

/**
 优惠券
 */
@interface WDIMCoupon : GLIMExtensionEntity

@property (nonatomic, strong) NSString *couponID;           // 优惠券ID
@property (nonatomic, strong) NSString *couponUrl;          // 优惠券H5链接
@property (nonatomic, strong) NSString *couponContent;      // 优惠券显示内容

@property (nonatomic, strong) NSString *shopID;             // 优惠券发送方店铺ID
@property (nonatomic, strong) NSString *shopName;           // 优惠券发送方店铺名称
@property (nonatomic, strong) NSString *shopImageUrl;       // 优惠券发送方店铺头像链接
@property (nonatomic, strong) NSString *adsk;               // 广告字段

@end

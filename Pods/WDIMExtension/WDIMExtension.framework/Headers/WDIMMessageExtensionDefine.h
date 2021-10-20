//
//  WDIMMessageExtensionDefine.h
//  WDIMExtension
//
//  Created by huangbiao on 2017/3/23.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#ifndef WDIMMessageExtensionDefine_h
#define WDIMMessageExtensionDefine_h

#pragma mark - 扩展消息类型
typedef NS_ENUM(NSInteger, WDIMMessageContentType) {
    WDIMMessageContentCoupon    = 6,        // 优惠券
    WDIMMessageContentMarketAD  = 10,       // 营销广告
    WDIMMessageContentReturnVisit = 101,    // 回访消息
    WDIMMessageContentGood      = 1000,     // 商品
    WDIMMessageContentSendGood  = 1028,     // 发送商品
    WDIMMessageContentOrder     = 1100,     // 订单
};

/// 扩展UI点击事件类型，参考GLIMMessageTapObject
typedef NS_ENUM(NSInteger, WDIMMessageTapObject) {
    WDIMMessageTapObjectCoupon = 100,   // 点击优惠券Cell
    WDIMMessageTapObjectGood = 101,     // 点击商品Cell
    WDIMMessageTapObjectCard = 102,     // 通用卡片Cell
    WDIMMessageTapObjectPayCard = 103,  // 点击微店付款Cell
    WDIMMessageTapObjectOrderCard = 104,// 点击订单卡片Cell
    
    WDIMMessageTapObjectGoodInCell = 105,   // 仅点击Cell中的商品
    WDIMMessageTapObjectOrderInCell = 106,  // 仅点击Cell中的订单
};

#pragma mark - 扩展Notification

#define WDIMNOTIFICATION_GOOD_SELECTED      @"WDIMNOTIFICATION_GOOD_SELECTED"
#define WDIMNOTIFICATION_COUPON_SELECTED    @"WDIMNOTIFICATION_COUPON_SELECTED"


#endif /* WDIMMessageExtensionDefine_h */

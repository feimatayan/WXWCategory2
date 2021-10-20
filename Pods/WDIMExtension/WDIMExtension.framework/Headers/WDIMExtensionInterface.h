//
//  WDIMExtensionInterFace.h
//  WDIMExtension
//
//  Created by 六度 on 2017/3/30.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "WDIMGood.h"
#import "WDIMOrder.h"
#import "WDIMCoupon.h"

@protocol WDIMExtensionEventProtocol <NSObject>

@required
/**
 打开H5页面
 
 @param url url链接
 @param needRiskCheck 是否需要进行风控检查
 */
- (void)imOpenH5PageWithUrl:(NSString *)url needRiskCheck:(BOOL)needRiskCheck;

/**
 打开用户详情页面

 @param userData 用户信息
 */
- (void)imOpenUserDetailPageWithUser:(GLIMUser *)userData;

/**
 打开用户详情 扩展方法

 @param userData 用户的信息
 @param jumpType 跳转的类型 0详细资料 1客户详情
 */
- (void)imOpenUserDetailPageWithUser:(GLIMUser *)userData jumpType:(NSInteger )jumpType;

@optional

/**
 打开H5页面

 @param url url链接
 @param needRiskCheck 是否需要进行风控检查
 @param callback 回调函数，返回消息字段信息
 */
- (void)imOpenH5PageWithUrl:(NSString *)url
              needRiskCheck:(BOOL)needRiskCheck
                   callback:(void (^)(NSDictionary *messageInfos))callback;

/**
 打开商品详情

 @param goodData 商品信息
 */
- (void)imOpenGoodDetailPageWithGood:(WDIMGood *)goodData;
- (void)imopenGoodDetailPageWithGoodDic:(NSDictionary *)goodDic;

/**
//打开特殊联系人 页面
dic
{
    chatid : @""
    title : @""
}
  */
- (void)imOpenRecentChatsTopSpecialContactsPageWithDic:(NSDictionary *)dic;


/**
 打开商品详情

 @param goodData 商品信息
 @param chat 联系人信息
 */
- (void)imOpenGoodDetailPageWithGood:(WDIMGood *)goodData withChat:(GLIMChat *)chat;

/**
 打开订单详情

 @param orderData 订单信息
 */
- (void)imOpenOrderDetailPageWithOrder:(WDIMOrder *)orderData;

/**
 打开商品列表页面

 @param callback 回调函数（返回商品数据）
 */
- (void)imOpenGoodListPageWithCallback:(void (^)(WDIMGood *goodData))callback;

/**
 打开商品列表页面

 @param callback 回调函数（返回商品数据）
 @param chat 当前联系对象
 */
- (void)imOpenGoodListPageWithCallback:(void (^)(WDIMGood *))callback withChat:(GLIMChat *)chat;

/**
 打开优惠券列表页面

 @param callback 回调函数（返回优惠券数据）
 */
- (void)imOpenCouponListPageWithCallback:(void (^)(NSDictionary *couponInfos))callback;

/**
 打开积分红包页面

 @param callback 回调函数（返回积分红包信息）
 */
- (void)imOpenScoreRedEnvelopPageWithCallback:(void (^)(NSDictionary *redEnvelopInfos))callback;

/**
 调用网关服务
 由于SDK内部有微店业务相关请求，而微店账号经常过期，因此提供这个接口来适配App的过期（权限）策略

 @param params 业务请求参数（目前是账号过期相关错误信息，后续可扩展）
 */
- (void)imCallGatewayServiceWithParams:(NSDictionary *)params;

#pragma mark - Group

/**
 打开群详情页面（暂时可不实现，后续业务会调整）

 @param group 群信息
 */
- (void)imOpenGroupDetailPageWithGroup:(GLIMGroup *)group;

/**
 打开群成员详情页面（暂时可不实现，后续业务会调整）

 @param groupMember 群成员
 @param group 群
 */
- (void)imOpenGroupMemberDetailPageWithMember:(GLIMGroupMember *)groupMember
                                     andGroup:(GLIMGroup *)group;

#pragma mark - 抱团/互助群
/**
 打开抱团群列表页面

 @param callback 回调函数，返回抱团群信息
 */
- (void)imOpenAssembleGroupListPageWithCallback:(void (^)(NSDictionary *assembleGroupInfos))callback;

/**
 打开抱团/互助群-跨店优惠券页面

 @param callback 回调函数，返回优惠券信息
 */
- (void)imOpenAssembleGroupCouponPageWithCallback:(void (^)(NSDictionary *couponInfos))callback;

#pragma mark - 回头客群
/**
 打开回头客专享优惠页面
 
 @param callback 回调函数，返回专享优惠信息
 */
- (void)imOpenRegularCustomerCouponPageWithCallback:(void (^)(NSDictionary *couponInfos))callback;

#pragma mark - CardCell

/**
 是否支持打开指定的卡片详情页面
 如果支持，则必须实现相应的imOpenCardDetailPageWithCardEntity方法，
 如果不支持，SDK提供内置的处理方法（未做特殊处理的卡片都是打开H5页面）

 @param cardEntity 卡片数据
 @return YES or NO
 */
- (BOOL)imSupportOpenCardDetailPageWithCardEntity:(GLIMCardEntity *)cardEntity;


/**
 根据对应卡片数据实现卡片的处理逻辑，
 对于卡片数据，imSupportOpenCardDetailPageWithCardEntity必须返回YES

 @param cardEntity 卡片数据
 */
- (void)imOpenCardDetailPageWithCardEntity:(GLIMCardEntity *)cardEntity;

@end

/**
 扩展接口，负责提供
 */
@interface WDIMExtensionInterface : NSObject

@property (nonatomic, weak) id<WDIMExtensionEventProtocol> eventDelegate;

+ (instancetype)sharedInstance;

/**
 配置统计信息
 */
- (void)configStatistics;

/**
 根据商品信息构造对应的文本消息
 生成的消息数据不包含消息发送和接收方，需要进一步补全参数

 @param goodData 商品数据
 @return 消息数据
 */
+ (GLIMMessage *)textMessageWithGood:(WDIMGood *)goodData;

/**
 根据卡片信息构造对应的卡片消息
 生成的消息数据不包含消息发送和接收方，需要进一步补全参数

 @param cardInfos 卡片信息，具体格式如下：{
 GLIMUIKEY_SHARE_MAIN_TITLE:@"卡片消息的title或分享的主标题",
 GLIMUIKEY_SHARE_TITLE:@"卡片消息的content或分享的标题",
 GLIMUIKEY_SHARE_SUB_TITLE:@"卡片消息的扩展信息或分享二级标题",
 GLIMUIKEY_SHARE_IMAGE_URL:@"图片链接",
 GLIMUIKEY_SHARE_DETAIL_URL:@"跳转链接",
 GLIMUIKEY_SHARE_EXT_INFOS:@"jsonString, app关心的扩展字段",
 GLIMUIKEY_SHARE_SCENE_TYPE:@(会话类型，默认为GLIMUIShareSceneSession),
 GLIMUIKEY_SHARE_TYPE:@(具体的卡片类型，整型)
 }
 @return 消息数据
 */
+ (GLIMMessage *)cardMessageWithCardInfos:(NSDictionary *)cardInfos;

/**
 向指定用户发送积分红包消息

 @param redEnvelope 红包信息，格式待定
 @param userID 指定聊天用户
 @param completion 回调函数
 */
- (void)sendScoreRedEnvelope:(id)redEnvelope
                  withUserID:(NSString *)userID
                  completion:(void (^)(id))completion;

/**
 向指定用户发送优惠券
 
 @param couponDictInfos 优惠券信息，格式待定  id(优惠券id) href(优惠券url) title(优惠券标题)
 @param userID 指定聊天用户
 @param completion 回调函数
 */
- (void)sendCoupon:(NSDictionary *)couponDictInfos
        withUserID:(NSString *)userID
        completion:(void (^)(id))completion;

/**
 发送默认的卡片消息

 @param cardDictInfos 卡片信息
 @param userID 指定聊天用户
 @param completion 回调函数
 */
- (void)sendCardMessage:(NSDictionary *)cardDictInfos
             withUserID:(NSString *)userID
             completion:(void (^)(id))completion;


/**
 给指定用户发送普通文本消息

 @param textString 文本内容
 @param userID 指定聊天用户
 @param completion 回调函数，出错返回NSError
 */
- (void)sendTextMessage:(NSString *)textString
             withUserID:(NSString *)userID
             completion:(void (^)(id))completion;

/**
 临时对外开放的跳转群H5详情页面
 后续会调整成native，

 @param group 群数据
 */
- (void)temporaryJump2Group:(GLIMGroup *)group;

/// 打开到上车团订单页面
/// @param orderId 订单id
- (void)jump2WttOrderDetailWithOrderId:(NSString *)orderId;

/// 打开上车团团活动页面
/// @param groupId 团活动id
/// @param shopId 店铺id
- (void)jump2WttGroupActivityWithGroupId:(NSString *)groupId shopId:(NSString *)shopId;

@end

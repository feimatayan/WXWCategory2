//
//  GLIMCardEntity.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/12/6.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMExtensionEntity.h"

extern NSString * const kGLIMCardTypeKey;
extern NSString * const kGLIMCardTitleKey;
extern NSString * const kGLIMCardContentKey;
extern NSString * const kGLIMCardImageUrlKey;
extern NSString * const kGLIMCardImageUrlListKey;
extern NSString * const kGLIMCardJumpUrlKey;
extern NSString * const kGLIMCardJumpUrlListKey;
extern NSString * const kGLIMCardExtraDataKey;
extern NSString * const kGLIMCardExtraContentKey;
extern NSString * const kGLIMCardUrlSchemeKey;
extern NSString * const kGLIMCardExtInfosKey;
extern NSString * const kGLIMCardHeadImageUrlKey;

/**
 消息卡片业务实例基类
 */
@interface GLIMCardEntity : GLIMExtensionEntity

/// 卡片类型
@property (nonatomic, assign) NSInteger cardType;
/// 卡片标题
@property (nonatomic, strong) NSString *cardTitle;//title
/// 卡片内容
@property (nonatomic, strong) NSString *cardContent;//text
/// 卡片的首图
@property (nonatomic, strong) NSString *cardImageUrl;//pic_url
/// 卡片的图片列表
@property (nonatomic, strong) NSArray *cardImageUrlList;
/// 卡片的跳转链接
@property (nonatomic, strong) NSString *cardJumpUrl;//jump_url
/// 卡片头像地址，可选——红包和优惠券底部头像图片链接
@property (nonatomic, strong) NSString *cardHeadUrl;//head_url
/// 卡片的跳转链接列表
@property (nonatomic, strong) NSArray *cardJumpUrlList;
/// 卡片的跳转ID（暂未使用）
@property (nonatomic, strong) NSString *cardJumpID;
/// 卡片的跳转ID列表（暂未使用）
@property (nonatomic, strong) NSArray *cardJumpIDList;
/// 卡片补充字段(JSON)
@property (nonatomic, strong) NSDictionary *dataInfos;
/// 扩展内容（从dataInfos中获取，用于显示，SDK需要关心）
@property (nonatomic, strong) NSString *extraContent; //subTitle
/// 新的扩展内容(jsonString, app自定义字段，SDK不关心）
@property (nonatomic, copy) NSString *cardExtInfos;
/// 扩展内容（从dataInfos中获取，用于区分具体业务数据，SDK可关心，如果上车团中的）
@property (nonatomic, assign) NSInteger extraSubType;// subType

/// 第三方App的UrlScheme
@property (nonatomic, strong) NSString *supportUrlScheme;


//data 的扩展字段 为了红包字段科配置
@property (nonatomic, copy) NSString *data_summary;
@property (nonatomic, copy) NSString *data_BottomText;
@property (nonatomic, copy) NSString *data_RedPacketUrl;

@end

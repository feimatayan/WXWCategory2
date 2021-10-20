//
//  WDIMGood.h
//  WDIMExtension
//
//  Created by huangbiao on 2017/3/25.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>

@interface WDIMGood : GLIMExtensionEntity

/// 店铺名称
@property (nonatomic, strong) NSString *shopName;
/// 商品ID
@property (nonatomic, strong) NSString *goodID;
/// 商品名称
@property (nonatomic, strong) NSString *goodName;
/// 商品链接
@property (nonatomic, strong) NSString *goodUrl;
/// 商品价格
@property (nonatomic, strong) NSString *goodPrice;
/// 商品图片
@property (nonatomic, strong) NSString *goodImageUrl;
/// 商品状态 1 - 在售；2 - 下架；3 - 删除
@property (nonatomic, assign) NSInteger goodStatus;
/// 跳转需要的参数
@property (nonatomic, strong) NSDictionary *jumpParams;

/// 生成商品信息
- (NSDictionary *)goodInfoDict;

/// 测试商品数据
+ (instancetype)mockGood;

@end

@interface WDIMSendGood : WDIMGood

@end

//
//  WDIMExtensionConfig.h
//  WDIMExtension
//
//  Created by huangbiao on 2017/3/22.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMUI/GLIMUI.h>

/**
 WDIMExtension组件配置
 */
@interface WDIMExtensionConfig : NSObject

+ (instancetype)sharedInstance;

/**
 判断视图是不是IM的视图
 
 @param viewController 视图
 @return YES or NO
 */
+ (BOOL)isImViewController:(UIViewController *)viewController;

#pragma mark - 旧接口，需要改进
- (void)configInputActions;

/**
 返回抱团群列表链接

 @param groupID 群ID
 @return 链接
 */
- (NSString *)assembleGroupListUrlWithGroupID:(NSString *)groupID;


/**
 返回抱团群跨店优惠券链接

 @param groupID 群ID
 @return 链接
 */
- (NSString *)assembleGroupCouponUrlWithGroupID:(NSString *)groupID;

/**
 返回回头客专享优惠链接

 @param groupID 群ID
 @return 链接
 */
- (NSString *)regularCustomerGroupCouponUrlWithGroupID:(NSString *)groupID;

/**
 根据聊天对象调整会话页面+号内按钮

 @param chat 聊天对象
 */
- (void)configSessionActionsWithChat:(GLIMChat *)chat;

#pragma mark - 临时
/// 买家版顶部特殊联系人开关，控制新旧UI显示 20201127
@property (nonatomic, assign) BOOL usingNewSpecialDatas;

@end

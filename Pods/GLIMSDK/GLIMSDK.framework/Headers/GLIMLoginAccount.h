//
//  GLIMLoginAccount.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"

@interface GLIMLoginAccount : GLIMBaseObject

#pragma mark - im
/// 当前登录账号的im系统uid，im系统的唯一标识
@property (nonatomic, strong) NSString *imLoginUID;
/// 当前登录账号的主账号的im系统uid，im系统的唯一标识
@property (nonatomic, strong) NSString *imMasterUID;
/// 当前登录账号的im系统token，用于im快速登录
@property (nonatomic, strong) NSString *imToken;
/// 是否使用imToken登录
@property (nonatomic, assign) BOOL usingImToken;

#pragma mark - 子账号
// 是否是子账号登录了
@property (nonatomic, assign) BOOL isBoyAccount;
// 子账号状态 YES在线 NO离线 默认值为YES
@property (nonatomic, assign) BOOL isBoyAccountOnline;
// 子账号是否有IM权限 默认值为YES
@property (nonatomic, assign) BOOL isBoyAccountHasIMAuthority;
// 子账号忙碌状态，YES 忙碌，默认为NO
@property (nonatomic, assign) BOOL isBoyAccountBusy;

#pragma mark - app
/// 当前登录账号的userID
@property (nonatomic, strong) NSString *userID;
/// 当前登录账号的userUss
@property (nonatomic, strong) NSString *userUss;
/// 当前登录账号的userToken
@property (nonatomic, strong) NSString *userToken;
/// app身份，1: 买家；2: 卖家
@property (nonatomic, assign) NSInteger userType;
/// app的duid
@property (nonatomic, strong) NSString *userDuid;


@property (nonatomic, strong) NSString *shopid;

/**
 检查两个账号是否一致

 @param loginAccount 另一个账号信息
 @return YES：账号相同
 */
- (BOOL)isEqualAccount:(GLIMLoginAccount *)loginAccount;


/**
 判断MasterUID是否有效（不为空且不为0）

 @return YES or NO
 */
- (BOOL)isValidMasterUID;

/// 重置子账号相关参数值
- (void)resetBoyAccountParams;

/// 判断子账号是否没有聊天权限
- (BOOL)isBoyAccountNoImAuthority;

/// 检查子账号是否在线或忙碌：可以参与聊天
- (BOOL)isBoyAccountOnlineOrBusy;
/// 当前账号主账号uid
- (NSString *)currentMasterUID;

@end

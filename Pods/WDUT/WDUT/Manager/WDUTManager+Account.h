//
//  WDUTManager+UserInfo.h
//  WDUTManager
//
//  Created by WeiDian on 15/12/24.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDUTManager.h"

@interface WDUTManager (Account)

/**
 * 同步用户信息到WT
 *
 * @deprecated 不建议使用
 * @param userId
 * @param phoneNumber
 */
- (void)userLogin:(NSString *)duid userId:(NSString *)userId phoneNumber:(NSString *)phoneNumber;

/**
 * 清除WT的用户信息
 *
 * @deprecated 不建议使用
 */
- (void)userLogout;

@end

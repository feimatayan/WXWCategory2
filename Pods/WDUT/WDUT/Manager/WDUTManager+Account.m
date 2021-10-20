//
//  WDUTManager+UserInfo.m
//  WDUTManager
//
//  Created by WeiDian on 15/12/24.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import "WDUTManager+Account.h"
#import "WDUTEventDefine.h"
#import "WDUTLogModel.h"
#import "NSMutableDictionary+WDUT.h"
#import "WDUTUtils.h"
#import "WDUTContextInfo.h"
#import "WDUTMacro.h"

@implementation WDUTManager (Account)

- (void)userLogin:(NSString *)duid userId:(NSString *)userId phoneNumber:(NSString *)phoneNumber {
    [WDUTContextInfo instance].userId = duid;
    [WDUTContextInfo instance].formatUserId = userId;
    [WDUTContextInfo instance].phoneNumber = phoneNumber;
    
    [self commitEvent:WDUT_EVENT_TYPE_SYS_LOGIN
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:duid
                 arg2:phoneNumber
                 arg3:nil
                 args:@{@"format_user_id": userId ?:@""}
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

- (void)userLogout {
    [WDUTContextInfo instance].userId = @"";
    [WDUTContextInfo instance].formatUserId = @"";
    [WDUTContextInfo instance].phoneNumber = @"";
}

@end

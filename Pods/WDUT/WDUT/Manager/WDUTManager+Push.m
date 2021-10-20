//
//  WDUTManager+Push.m
//  WDUTManager
//
//  Created by WeiDian on 15/12/24.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import "WDUTManager+Push.h"
#import "WDUTEventDefine.h"
#import "WDUTLogModel.h"
#import "WDUTMacro.h"
#import "WDUTUtils.h"

#define kWDUTFAppFirstInstallFlagKey  @"first_install_key"

@implementation WDUTManager (Push)

- (void)pushRegister:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args {
    [self commitEvent:WDUT_EVENT_TYPE_PUSH_TOKEN
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:arg1
                 arg2:arg2
                 arg3:arg3
                 args:args
             reserved:nil 
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

- (void)pushArrive:(NSString *)arg1
              arg2:(NSString *)arg2
              arg3:(NSString *)arg3
              args:(NSDictionary *)args {
    [self commitEvent:WDUT_EVENT_TYPE_PUSH_ARRIVE
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:arg1
                 arg2:arg2
                 arg3:arg3
                 args:args
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

- (void)pushDisplay:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args {
    [self commitEvent:WDUT_EVENT_TYPE_PUSH_DISPLAY
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:arg1
                 arg2:arg2
                 arg3:arg3
                 args:args
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

- (void)pushOpen:(NSString *)arg1
            arg2:(NSString *)arg2
            arg3:(NSString *)arg3
            args:(NSDictionary *)args {
    [self commitEvent:WDUT_EVENT_TYPE_PUSH_OPEN
             pageName:WDUT_PAGE_FIELD_UT
                 arg1:arg1
                 arg2:arg2
                 arg3:arg3
                 args:args
             reserved:nil
            isSuccess:YES
             priority:WDUTReportStrategyBatch];
}

#pragma mark - private methods

- (BOOL)isAllowedPushNotification {
    if ([WDUTSharedApplication() respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationType types = [[WDUTSharedApplication() currentUserNotificationSettings] types];
        if (UIUserNotificationTypeNone != types) {
            return YES;
        }
    }

    if ([WDUTSharedApplication() respondsToSelector:@selector(enabledRemoteNotificationTypes)]) {
        UIRemoteNotificationType type = [WDUTSharedApplication() enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type) {
            return YES;
        }
    }
    
    return NO;
}

@end


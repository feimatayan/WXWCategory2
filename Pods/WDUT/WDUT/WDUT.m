//
//  WDUT.m
//  WDUT
//
//  Created by WeiDian on 15/12/24.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import "WDUT.h"
#import "WDUTManager.h"
#import "WDUTManager+Push.h"
#import "WDUTManager+Account.h"
#import "WDUTContextInfo.h"
#import "WDUTSessionManager.h"
#import "WDUTBuilder.h"
#import "WDUTManager+LifeCycle.h"
#import "WDUTLocationManager.h"
#import "WDUTDef.h"

#define kWDUTDefaultChannelId @"appstore"

@implementation WDUT
#pragma mark - start

+ (void)startWithAppKey:(NSString *)appKey {
    [[WDUTManager sharedInstance] startWithAppKey:appKey
                                        channelId:kWDUTDefaultChannelId];
}

+ (void)setEnvType:(WDUTEnvType)envType {
    [WDUTConfig instance].envType = envType;
    
//    if (envType == WDUT_ENV_DAILY || envType == WDUT_ENV_PRE) {
//        [WDUTConfig instance].debugMode = YES;
//    } else {
//        [WDUTConfig instance].debugMode = NO;
//    }
}

+ (NSString *)getCuid {
    return [WDUTContextInfo instance].cuid;
}

+ (NSString *)getSuid {
    return [WDUTContextInfo suid];
}

+ (NSString *)getDeviceId {
    return [WDUTContextInfo instance].cuid;
}

+ (NSString *)getSessionId {
    return [WDUTSessionManager getSessionId];;
}

+ (void)setPatchVersion:(NSString *)patchVersion {
    [WDUTContextInfo instance].patchVersion = patchVersion;
}

+ (void)setChannel:(NSString *)channel {
    [WDUTContextInfo instance].channel = channel;
}

+ (void)enableUT:(BOOL)enable {
    [WDUTConfig instance].utEnable = enable;
}

+ (void)setDuid:(NSString *)duid userId:(NSString *)userId phoneNumber:(NSString *)phoneNumber {
    [WDUTContextInfo instance].userId = duid;
    [WDUTContextInfo instance].formatUserId = userId;
    [WDUTContextInfo instance].phoneNumber = phoneNumber;
}

+ (void)setShopId:(NSString *)shopId {
    [WDUTContextInfo instance].shopId = shopId;
}

+ (void)setLocationTrackManually:(BOOL)manually {
    [WDUTConfig instance].locationTrackManually = manually;
}

+ (void)setLatitude:(NSString *)latitude longitude:(NSString *)longitude {
    [WDUTLocationManager sharedInstance].longitude = longitude;
    [WDUTLocationManager sharedInstance].latitude = latitude;
}

+ (NSString *)getLatitude {
    return [[WDUTLocationManager sharedInstance].latitude copy];
}

+ (NSString *)getLongitude {
    return [[WDUTLocationManager sharedInstance].longitude copy];
}

+ (void)setPageTrackManually:(BOOL)manually {
    [WDUTConfig instance].pageTrackManually = manually;
}

+ (void)addFilteredPageArray:(NSArray *)pageArray {
    [[WDUTConfig instance].filteredPageList addObjectsFromArray:pageArray];
}

+ (void)addSpecialPages:(NSArray *)specialPages {
    [[WDUTConfig instance].specialPages addObjectsFromArray:specialPages];
}

#pragma mark - event

+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args {
    [self commitEvent:eventId args:args policy:WDUTReportStrategyBatch];
}

+ (void)commitEvent:(NSString *)eventId args:(NSDictionary *)args policy:(WDUTReportStrategy)policy {
    [self commitEvent:eventId pageName:nil arg1:nil arg2:nil arg3:nil args:args isSuccess:YES policy:policy];
}

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args {
    [self commitEvent:eventId pageName:pageName arg1:arg1 arg2:arg2 arg3:arg3 args:args isSuccess:YES policy:WDUTReportStrategyBatch];
}

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
             policy:(WDUTReportStrategy)policy {
    [self commitEvent:eventId pageName:pageName arg1:arg1 arg2:arg2 arg3:arg3 args:args isSuccess:YES policy:policy];
}

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
          isSuccess:(BOOL)isSuccess {
    [self commitEvent:eventId pageName:pageName arg1:arg1 arg2:arg2 arg3:arg3 args:args isSuccess:isSuccess policy:WDUTReportStrategyBatch];
}

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
          isSuccess:(BOOL)isSuccess
             policy:(WDUTReportStrategy)policy {
    [self commitEvent:eventId pageName:pageName arg1:arg1 arg2:arg2 arg3:arg3 args:args module:nil isSuccess:isSuccess policy:policy];
}

+ (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
             module:(NSString *)module
          isSuccess:(BOOL)isSuccess
             policy:(WDUTReportStrategy)policy {
    NSDictionary *reserved = nil;
    if (module.length > 0) {
        reserved = @{WDUT_EVENT_FIELD_RESERVE2: module};
    }
    [[WDUTManager sharedInstance] commitEvent:eventId
                                     pageName:pageName
                                         arg1:arg1
                                         arg2:arg2
                                         arg3:arg3
                                         args:args
                                     reserved:reserved
                                    isSuccess:isSuccess
                                     priority:policy];
}

+ (void)commitClickEvent:(NSString *)controlName args:(NSDictionary *)args {
    [self commitClickEvent:controlName args:args policy:WDUTReportStrategyBatch];
}

+ (void)commitClickEvent:(NSString *)controlName
                    args:(NSDictionary *)args
                  policy:(WDUTReportStrategy)policy {
    [[WDUTManager sharedInstance] commitClickEvent:controlName
                                              args:args
                                          priority:policy];
}

#pragma mark - page

+ (void)updateViewController:(id)controller
                    pageName:(NSString *)pageName {
    [self updateViewController:controller pageName:pageName args:nil];
}

+ (void)updateViewController:(id)controller
                    pageName:(NSString *)pageName
                        args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] updateController:controller pageName:pageName args:args];
}

+ (NSString *)getPageNameWithController:(id)controller {
    return [[WDUTManager sharedInstance] getPageNameWithController:controller];
}

+ (void)updateViewController:(id)controller
                    pageName:(NSString *)pageName
                segmentation:(NSDictionary *)segmentation {
    [[WDUTManager sharedInstance] updateController:controller
                                          pageName:pageName
                                              args:segmentation];
}

+ (void)pageAppear:(UIViewController *)page {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WDUTManager sharedInstance] pageAppear:page];
    });
}

+ (void)pageDisappear:(UIViewController *)page pageName:(NSString *)pageName{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WDUTManager sharedInstance] pageDisappear:page pageName:pageName];
    });
}

+ (void)commitPageEventManually:(id)controller {
    [[WDUTManager sharedInstance] commitPageEventManually:controller];
}

#pragma mark - user info

+ (void)pushRegisterDeviceToken:(NSString *)arg1
                           arg2:(NSString *)arg2
                           arg3:(NSString *)arg3
                           args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] pushRegister:arg1
                                          arg2:arg2
                                          arg3:arg3
                                          args:args];
}

+ (void)pushRegister:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] pushRegister:arg1
                                          arg2:arg2
                                          arg3:arg3
                                          args:args];
}

+ (void)pushArrive:(NSString *)arg1
              arg2:(NSString *)arg2
              arg3:(NSString *)arg3
              args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] pushArrive:arg1
                                        arg2:arg2
                                        arg3:arg3
                                        args:args];
}

+ (void)pushDisplay:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] pushDisplay:arg1
                                         arg2:arg2
                                         arg3:arg3
                                         args:args];
}

+ (void)pushOpen:(NSString *)arg1
            arg2:(NSString *)arg2
            arg3:(NSString *)arg3
            args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] pushOpen:arg1
                                      arg2:arg2
                                      arg3:arg3
                                      args:args];
}

+ (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args {
    [[WDUTManager sharedInstance] itemExposure:arg1
                                          arg2:arg2
                                          arg3:arg3
                                          args:args
                                      pageName:nil
                                    controller:nil];
}

+ (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args
            pageName:(NSString *)pageName {
    [[WDUTManager sharedInstance] itemExposure:arg1
                                          arg2:arg2
                                          arg3:arg3
                                          args:args
                                      pageName:pageName
                                    controller:nil];
}

+ (void)itemExposure:(NSString *)arg1
                arg2:(NSString *)arg2
                arg3:(NSString *)arg3
                args:(NSDictionary *)args
            pageName:(NSString *)pageName
          controller:(UIViewController *)controller {
    [[WDUTManager sharedInstance] itemExposure:arg1
                                          arg2:arg2
                                          arg3:arg3
                                          args:args
                                      pageName:pageName
                                    controller:controller];
}

#pragma mark - deprecated

+ (void)commitEvent:(NSString *)eventId {
    [WDUT commitEvent:eventId args:nil];
}

+ (void)commitEvent:(NSString *)eventId segmentation:(NSDictionary *)segmentation {
    [[WDUTManager sharedInstance] commitEvent:eventId pageName:nil arg1:nil arg2:nil arg3:nil args:segmentation reserved:nil isSuccess:YES priority:WDUTReportStrategyBatch];
}

+ (void)commitCtrlClickedEvent:(NSString *)controlName segmentation:(NSDictionary *)segmentation {
    [[WDUTManager sharedInstance] commitClickEvent:controlName args:segmentation priority:WDUTReportStrategyBatch];
}

+ (NSString *)getWDUDID {
    return [WDUTContextInfo instance].cuid;
}

/**
 * @deprecated Use getSessionId: instead.
 * @return NSString
 */
+ (NSString *)getSessionID {
    return [WDUTSessionManager getSessionId];;
}

@end




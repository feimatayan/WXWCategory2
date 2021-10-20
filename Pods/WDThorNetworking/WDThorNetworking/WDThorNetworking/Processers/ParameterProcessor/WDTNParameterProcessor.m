//
//  WDTNParameterProcessor.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNParameterProcessor.h"
#import "WDTNNetwrokConfig.h"
#import "WDTNPerformTask.h"
#import "WDTNRequestConfig.h"
#import "WDTNUtils.h"
#import "WDTNDefines.h"
#import "WDTNServerClockProofreader.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJDeviceInfo/WDBJDeviceInfo.h>
#import <WDBJEncryptUtil/GLDataSignKeyContainer.h>
#import <RealReachability/LocalConnection.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@implementation WDTNParameterProcessor

static CTTelephonyNetworkInfo *realchabilityTeleInfo;
static NSMutableDictionary *_cachedConfigHeaders = nil;

+ (void)initCachedHeadersIfNecessary {
    if (_cachedConfigHeaders == nil) {
        _cachedConfigHeaders = [[NSMutableDictionary alloc] init];
    }
}

/**
 一种config对应一种header.
 */
+ (NSDictionary *)HTTPHeaderFields:(WDTNRequestConfig *)config {
    [self.class initCachedHeadersIfNecessary];
    
    NSMutableDictionary *header = _cachedConfigHeaders[config.configType];
    if (header == nil) {
        header = [NSMutableDictionary dictionary];
        // @"encryType" NSNumber类型，取值： 0:不加密， 2:加密;
        header[@"encryType"] = [NSString stringWithFormat:@"%ld", (long)config.reqEncryStatus];
        // @"gzipType": NSNumber类型，0：不压缩,1：压 缩;
        header[@"gzipType"] = [NSString stringWithFormat:@"%ld", (long)config.reqZipType];
        
        // 设置 apiv 和 appid
        id<WDTNVarHeaderOnSceneDelegate> sceneDelegate = config.varHeaderDelegate;
        
        //增加delegate方法varHeaderItemOnScene的线程安全
        @synchronized (sceneDelegate) {
            NSDictionary *sceneDic = [sceneDelegate varHeaderItemOnScene];
            header[@"apiv"] = sceneDic[@"apiv"];
            header[@"appid"] = sceneDic[@"appid"];
        }
        
        header[@"Accept-Encoding"] = @"GLZip";
        header[@"Content-Encoding"] = @"GLZip";
        header[@"Content-Type"] = @"application/x-www-form-urlencoded";
        
        // cache
        _cachedConfigHeaders[config.configType] = header;
    }
    
    // 内部使用，不需要返回copy对象.
    return header;
}

+ (NSData *)HTTPBody:(NSDictionary *)customParams task:(WDTNPerformTask *)task error:(NSError **)error {
    
    NSInteger gzipType = task.config.reqZipType;
    NSInteger encryType = task.config.reqEncryStatus;
    NSString *keyid = task.config.passKeyId;
    NSString *signid = task.config.signKeyId;
    
    // 微店定制的header
    NSDictionary *wdHeader = [self.class packWDHttpRequestHeader:task];
    
    // 整合口袋自定义请求格式的源数据,先压缩，后加密
    NSString *strHeader = [WDTNUtils stringFromJSONObject:wdHeader];
    if (strHeader == nil) {
        strHeader = @"{}";
    }
    NSString *strBody = [WDTNUtils stringFromJSONObject:customParams];
    if (strBody == nil) {
        strBody = @"{}";
    }
    NSString *strWDBody = [NSString stringWithFormat:@"{\"header\":%@,\"body\":%@}",strHeader,strBody];
    NSData *curData = [strWDBody dataUsingEncoding:NSUTF8StringEncoding];

    // 添加本地日志打印数据
    task.publicParams = strWDBody;

    NSData *processData = curData;
    if (task.config.requestPipeline != nil) {
        processData = [task.config.requestPipeline processData:curData error:error];
    }
    
    // 压缩或加密失败，返回 nil.
    if (error != NULL && *error != nil) {
        return nil;
    }
    
    // base64 编码
    strWDBody = [GLCharCodecUtil base64Encoding:processData];
    
    // 签名校验算法
    NSString* signkey = [[GLDataSignKeyContainer sharedManager] signKeyByID:signid];//[glHeader objectForKey:@"proxysignidKey"];
    NSString* tempStr = [NSString stringWithFormat:@"edata=%@signid=%@",strWDBody, signkey];
    NSString* md5Data = [GLCharCodecUtil md5:tempStr];
    md5Data = [md5Data substringFromIndex:[md5Data length] - 16]; // 后16位
    
    // 对结果做urlencode
    strWDBody = [strWDBody urlEncode];
    
    // 口袋自定义格式
    // "platform=*&apiv＝*&gzipType=*&encryType=*&kid=*&crc=*&edata=*"；
    NSString* platform = [wdHeader objectForKey:@"platform"];
    NSString* apiversion = [wdHeader objectForKey:@"apiv"];
    NSString* guid = [wdHeader objectForKey:@"guid"];
    strWDBody = [NSString stringWithFormat:@"platform=%@&apiv=%@&guid=%@&gzipType=%ld&encryType=%ld&keyid=%@&kid=%@&signid=%@&proxysign=%@&edata=%@",
                 platform?platform:@"", apiversion?apiversion:@"", guid?guid:@"",
                 (long)gzipType, (long)encryType, keyid, keyid, signid?signid:@"",md5Data, strWDBody];
    
    NSData *result = [strWDBody dataUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

#pragma mark - help methods

/**
 微店定制的header
 */
static NSDictionary *deviceInfo = nil;

+ (NSDictionary *)packWDHttpRequestHeader:(WDTNPerformTask *)task {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
    if (deviceInfo == nil) {
        id<WDTNStaticHeaderOnSceneDelegate> sceneDelegate = task.config.staticHeaderDelegate;
        if (sceneDelegate != nil) {
            deviceInfo = [sceneDelegate staticDeviceInfo];
        } else {
            deviceInfo = getStaticDeviceInfo();
        }
    }
    
    [headers addEntriesFromDictionary:deviceInfo];
    
    // 2. 其他参数
    NSString *network = [self.class network];
    headers[@"network"] = network;
    if ([network isEqualToString:@"WIFI"] || [network isEqualToString:@"UNKNOWN"] || [network isEqualToString:@"NoNetwork"]) {
        headers[@"netsubtype"] = @"";
    } else {
        NSString *currentAccessTechnology = [self currentRadioAccessTechnology];
        headers[@"netsubtype"] = currentAccessTechnology ? currentAccessTechnology : @"";
    }
    
    BOOL isSystemTime = NO;
    long long stamp = [[WDTNServerClockProofreader sharedInstance] currentTime:&isSystemTime];
    NSString *strStamp = [NSString stringWithFormat:@"%lld",stamp];
    headers[@"net_timestamp"] = strStamp;
    if (isSystemTime == YES) {
        headers[@"net_timestamp_type"] = @"server";
    } else {
        headers[@"net_timestamp_type"] = @"local";
    }

    id<WDTNVarHeaderOnSceneDelegate> sceneDelegate = task.config.varHeaderDelegate;
    
    //增加delegate方法varHeaderItemOnScene的线程安全
    @synchronized (sceneDelegate) {
        NSDictionary *dicItem = [sceneDelegate varHeaderItemOnScene];
        [headers addEntriesFromDictionary:dicItem];
    }
    
    return headers;
}

+ (NSString *)currentRadioAccessTechnology {
    if (!realchabilityTeleInfo) {
        @synchronized (self) {
            if (!realchabilityTeleInfo) {
                realchabilityTeleInfo = [[CTTelephonyNetworkInfo alloc] init];
            }
        }
    }

    return realchabilityTeleInfo.currentRadioAccessTechnology;
}

+ (WDNThorStatus)currentLocalNetworkStatus {
    [GLocalConnection startNotifier];
    LocalConnectionStatus localStatus = [GLocalConnection currentLocalConnectionStatus];
    WDNThorStatus networkStatus = WDNThorStatusNotReachable;
    if (localStatus == LC_WiFi) {
        networkStatus = WDNThorStatusWIFI;
    }else if (localStatus == LC_WWAN){
        WDNThorAccessType accessType = [self accessTypeForString:[self currentRadioAccessTechnology]];
        if (accessType == WDNThorAccessType2G){
            networkStatus = WDNThorStatus2G;
        } else if (accessType == WDNThorAccessType3G){
            networkStatus = WDNThorStatus3G;
        } else if (accessType == WDNThorAccessType4G){
            networkStatus = WDNThorStatus4G;
        } else{
            networkStatus = WDNThorStatusMobile;
        }
    }
    return networkStatus;
}

+ (WDNThorAccessType)accessTypeForString:(NSString *)accessString {
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    if ([typeStrings4G containsObject:accessString]) {
        return WDNThorAccessType4G;
    } else if ([typeStrings3G containsObject:accessString]) {
        return WDNThorAccessType3G;
    } else if ([typeStrings2G containsObject:accessString]) {
        return WDNThorAccessType2G;
    } else {
        return WDNThorAccessTypeUnknown;
    }
}

+ (NSString *)network {
    WDNThorStatus status = [self currentLocalNetworkStatus];
    NSString *resut = @"";
    switch (status) {
        case WDNThorStatus2G:
            resut = @"2G";
            break;
            
        case WDNThorStatus3G:
            resut = @"3G";
            break;
            
        case WDNThorStatus4G:
            resut = @"4G";
            break;
            
        case WDNThorStatusWIFI:
            resut = @"WIFI";
            break;
            
        case WDNThorStatusNotReachable:
            resut = @"NoNetwork";
            break;
            
        case WDNThorStatusMobile:
            resut = @"Mobile";
            break;
            
        default:
            resut = @"UNKNOWN";
            break;
            
    }
    return resut;
}

@end

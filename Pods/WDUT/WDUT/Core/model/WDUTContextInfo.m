//
//  WDUTContextInfo.m
//  WDUT
//
//  Created by WeiDian on 15/12/25.
//  Copyright © 2015 WeiDian. All rights reserved.
//

#import "WDUTContextInfo.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach-o/arch.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIDevice.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <objc/runtime.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIScreen.h>
#import "WDUTUtils.h"
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#import "WDUTEventDefine.h"
#import "WDUTConfig.h"
#import "WDUTManager.h"
#import "WDUTKeychainWrapper.h"
#import "WDUTService.h"
#import "WDUTMacro.h"
#import "NSMutableDictionary+WDUT.h"
#import "WDUTLocationManager.h"
#import "WDUTDef.h"
#import "WDUTLogModel.h"
#import "NSString+WDUT.h"
#import <AppTrackingTransparency/ATTrackingManager.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static NSString *gSuid = nil;
//static NSString *rooted = nil;


#define WDUT_KEYCHAIN_CUID  ([([WDUTConfig instance].envType == WDUT_ENV_DAILY ? @"WDUT_TEST_" : @"WDUT_RELEASE_") stringByAppendingString:@"KEYCHAIN_CUID"])

#define WDUT_KEYCHAIN_SUID  ([([WDUTConfig instance].envType == WDUT_ENV_DAILY ? @"WDUT_TEST_" : @"WDUT_RELEASE_") stringByAppendingString:@"KEYCHAIN_SUID"])

#define GLA_Keychain_CUID  ([([WDUTConfig instance].envType == WDUT_ENV_DAILY ? @"GLATest_" : @"GLARelease_") stringByAppendingString:@"Keychain_CUID"])

#define GLA_Keychain_SUID  ([([WDUTConfig instance].envType == WDUT_ENV_DAILY ? @"GLATest_" : @"GLARelease_") stringByAppendingString:@"Keychain_SUID"])

#define WDUT_CONFIG_SDK_TYPE           @"hz"
#define WDUT_CONFIG_SDK_VERSION        @"2.0"
#define WDUT_DUMMY_MAC_ADDR  @"02:00:00:00:00:00"

@implementation WDUTContextInfo {
    Reachability *_reachability;

    CTTelephonyNetworkInfo *_networkInfo;
    
    NSString *_cuid;
}

+ (WDUTContextInfo *)instance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {

        [self prepareCuid];
        [self startNetworkNotifier];
        [self startCarrierNotifier];
        _currentIpString = [WDUTContextInfo getIPAddress:YES];

        BOOL isJailBroken = [WDUTContextInfo isJailbroken];
        _rooted = isJailBroken ? @"1" : @"0";

        [self buildSteadyContext];
    }

    return self;
}

- (void)buildSteadyContext {
    _steadyContextInfo = [NSMutableDictionary dictionary];

    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_ACCESS];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_ACCESS_TYPE];
    [_steadyContextInfo setObject:@"APPLE" forKey:WDUT_EVENT_FIELD_BRAND];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_CARRIER];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_CLIENTIP];
    [_steadyContextInfo wdutSetObject:[WDUTContextInfo cpu] forKey:WDUT_EVENT_FIELD_CPU];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_DEVICEID];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_CUID];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_SUID];
    [_steadyContextInfo wdutSetObject:[WDUTContextInfo deviceModel] forKey:WDUT_EVENT_FIELD_DEVICE_MODEL];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_IMEI];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_IMSI];
    [_steadyContextInfo wdutSetObject:[WDUTContextInfo language] forKey:WDUT_EVENT_FIELD_LANGUAGE];
    [_steadyContextInfo setObject:@"iPhone" forKey:WDUT_EVENT_FIELD_OS];
    [_steadyContextInfo wdutSetObject:[WDUTContextInfo osVersion] forKey:WDUT_EVENT_FIELD_OS_VERSION];
    [_steadyContextInfo wdutSetObject:[WDUTContextInfo resolution] forKey:WDUT_EVENT_FIELD_RESOLUTUON];

    [_steadyContextInfo wdutSetObject:[WDUTContextInfo idfv] forKey:WDUT_EVENT_FIELD_IDFV];

    //用户信息
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_BUYERID];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_PHONE_NUMBER];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_USERID];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_FORMAT_USERID];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_SHOPID];

    //新增
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_LATITUDE];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_LONGITUDE];

    /// app配置相关通用信息
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_APP_KEY];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_CHANNEL];
    [_steadyContextInfo setObject:WDUT_CONFIG_SDK_TYPE forKey:WDUT_EVENT_FIELD_SDK_TYPE];
    [_steadyContextInfo setObject:WDUT_CONFIG_SDK_VERSION forKey:WDUT_EVENT_FIELD_SDK_VERSION];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_APP_VERSION];

    [_steadyContextInfo setObject:WDUT_CONFIG_PROTOCOL_VERSION forKey:WDUT_EVENT_FIELD_PROTOCOL_VERSION];

    //风控需求
    [_steadyContextInfo setObject:WDUT_DUMMY_MAC_ADDR forKey:WDUT_EVENT_FIELD_MAC];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_PROXY];
    [_steadyContextInfo setObject:_rooted forKey:WDUT_EVENT_FIELD_ROOTED];

    /// 暂时不用关心的字段，但也需要有占位符，方便后端解析
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_ARG1];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_ARG2];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_ARG3];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_ARGS];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_RESERVE1];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_RESERVE2];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_RESERVE3];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_RESERVE4];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_RESERVE5];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_RESERVES];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_SEQ];
    [_steadyContextInfo setObject:@"" forKey:WDUT_EVENT_FIELD_SERVER_TIMESTAMP];
}

/*
 * 优先从 WDUT_KEYCHAIN_CUID读取cuid；
 * 如果没有，读取GLA_Keychain_CUID;
 * 如果没有，生成cuid;
 * cuid存入WDUT_KEYCHAIN_CUID和GLA_Keychain_CUID
 *
 * */
- (void)prepareCuid {
    _cuid = [self oldCuid];
    if (_cuid.length == 0) {
        //读取共享keychain中cuid失败，生成新的cuid
        // 生成 cuid
        NSString *uuid = [WDUTContextInfo getUUID];
        _cuid = [[uuid wdutMD5] lowercaseString];
        
        // 保存cuid到一个新位置，为接下来sdk替换做准备
        [WDUTKeychainWrapper savePrivateData:[_cuid dataUsingEncoding:NSUTF8StringEncoding] forKey:WDUT_KEYCHAIN_CUID];
    }
}

- (NSString *)oldCuid {
    //改成新的存储位置
    NSData *data = [WDUTKeychainWrapper loadPrivateDataForKey:WDUT_KEYCHAIN_CUID];
    NSString *cuid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
    return cuid;
}

- (void)setCuid:(NSString *)cuid {
    @synchronized (_cuid) {
        _cuid = [cuid copy];
    }
}

- (NSString *)cuid {
    @synchronized (_cuid) {
        return _cuid;
    }
}

- (void)startNetworkNotifier {
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    [self updateDeviceNetStatus:_reachability];
    _reachability.reachableBlock = ^(Reachability *innerReachability) {
        [self updateDeviceNetStatus:innerReachability];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWDUTNetworkChangedNotification object:nil];
    };
    _reachability.unreachableBlock = ^(Reachability *innerReachability) {
        [self updateDeviceNetStatus:innerReachability];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWDUTNetworkChangedNotification object:nil];
    };
}

- (void)updateDeviceNetStatus:(Reachability *)reachability {
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi) {
        _currentNetworkString = @"WI-FI";
    } else if (status == ReachableViaWWAN) {
        CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = networkStatus.currentRadioAccessTechnology;
        if (currentStatus == CTRadioAccessTechnologyLTE) {
            _currentNetworkString = @"4G";
        } else if (currentStatus == CTRadioAccessTechnologyEdge
                || currentStatus == CTRadioAccessTechnologyGPRS) {
            _currentNetworkString = @"2G";
        } else {
            _currentNetworkString = @"3G";
        }
    } else {
        _currentNetworkString = @"unknow";
    }

    _currentNetworkStatus = status;
}

- (void)startCarrierNotifier {
    _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    [self updateCarrier:_networkInfo.subscriberCellularProvider];
    /// 运营商监听
    __weak typeof(self) weakSelf = self;
    _networkInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) {
        [weakSelf updateCarrier:carrier];
    };
}

- (void)updateCarrier:(CTCarrier *)carrier {
    _currentCarrierString = @"";
    NSString *mcc = [carrier mobileCountryCode] ?: @"";
    NSString *mnc = [carrier mobileNetworkCode] ?: @"";
    if (mnc && mnc.length >= 1 && ![mnc isEqualToString:@"SIM Not Inserted"]) {
        if ([mcc isEqualToString:@"460"]) {
            NSInteger MNC = [mnc intValue];
            switch (MNC) {
                case 0:
                case 2:
                case 7:
                case 8:
                    _currentCarrierString = @"中国移动";
                    break;
                case 1:
                case 6:
                case 9:
                    _currentCarrierString = @"中国联通";
                    break;
                case 3:
                case 5:
                case 11:
                    _currentCarrierString = @"中国电信";
                    break;
                case 20:
                    _currentCarrierString = @"中国铁通";
                    break;
                default:
                    _currentCarrierString = @"";
                    break;
            }
        }
    }
}

- (NSMutableDictionary *)steadyContextInfo {
    if (!_steadyContextInfo[WDUT_EVENT_FIELD_IDFA] ) {
        if (@available(iOS 14, *)) {
            if (ATTrackingManager.trackingAuthorizationStatus != ATTrackingManagerAuthorizationStatusNotDetermined) {
                [_steadyContextInfo wdutSetObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:WDUT_EVENT_FIELD_IDFA];
            }
        } else {
            [_steadyContextInfo wdutSetObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:WDUT_EVENT_FIELD_IDFA];
        }
    }

    return _steadyContextInfo;
}

+ (NSString *)appVersion {
    NSString *versionString = [WDUTUtils getAppVersion];
    if ([WDUTContextInfo instance].patchVersion.length > 0) {
        versionString = [NSString stringWithFormat:@"%@.p%@", versionString, [WDUTContextInfo instance].patchVersion];
    }

    return versionString;
}

+ (NSString *)suid {
    static BOOL hasCheckCache = NO;
    if (gSuid.length == 0 && !hasCheckCache) {
        @synchronized (self) {
            if (gSuid.length == 0 && !hasCheckCache) {
                hasCheckCache = YES;

                //只从原GLAnalysis存储的位置读取suid
                gSuid = [self oldSuid];
                if (gSuid.length == 0) {
                    //如果本地没有suid(即视为新用户)，返回cuid
                    gSuid = [WDUTContextInfo instance].cuid;
                    
                    // 保存suid到一个新位置，为接下来sdk替换做准备
                    [WDUTKeychainWrapper savePrivateData:[gSuid dataUsingEncoding:NSUTF8StringEncoding] forKey:WDUT_KEYCHAIN_SUID];
                }
            }
        }
    }

    return gSuid;
}

+ (NSString *)oldSuid {
    //改成新的存储位置
    NSData *data = [WDUTKeychainWrapper loadPrivateDataForKey:WDUT_KEYCHAIN_SUID];
    NSString *suid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
    return suid;
}

+ (NSString *)idfv {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark -获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
            @[IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6] :
            @[IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4];

    NSDictionary *addresses = [self getIPAddresses];
    WDUTLog(@"addresses: %@", addresses);

    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        /// 筛选出IP地址格式
        if ([self isValidatIP:address]) *stop = YES;
    }];

    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }

    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                         "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                         "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                         "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx
                                                                           options:0
                                                                             error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:ipAddress
                                                             options:0
                                                               range:NSMakeRange(0, [ipAddress length])];
        if (firstMatch) {
            return YES;
        }
    }

    return NO;
}

+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *) interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *) interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }

    return [addresses count] ? addresses : nil;
}

+ (NSString *)cpu {
    const NXArchInfo *archInfo = NXGetLocalArchInfo();
    int type = archInfo->cpusubtype;
    return [NSString stringWithFormat:@"%d", type];
}

+ (NSString *)deviceModel {
    char *modelKey = "hw.machine";
    size_t size;
    sysctlbyname(modelKey, NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname(modelKey, model, &size, NULL, 0);

    NSString *modelString = nil;
    if (model) {
        modelString = @(model);
    }

    free(model);

    return modelString;
}

+ (NSString *)language {
    return [[NSLocale currentLocale] localeIdentifier];
}

+ (NSString *)osVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)resolution {
    CGRect bounds = UIScreen.mainScreen.bounds;
    CGFloat scale = [UIScreen.mainScreen respondsToSelector:@selector(scale)] ? [UIScreen.mainScreen scale] : 1.f;
    return [NSString stringWithFormat:@"%g*%g", bounds.size.width * scale, bounds.size.height * scale];
}

+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }

    return jailbroken;
}

+ (NSString *)isViaProxy {
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]) {
        return @"0";
    }else{
        return @"1";
    }
}

#pragma mark -前后台监听

+ (void)onWillEnterForegroundNotification:(NSNotification *)notification {
    [WDUTContextInfo instance].currentIpString = [WDUTContextInfo getIPAddress:YES];
}

#pragma mark -重试获取suid

+ (NSMutableDictionary *)getContextInfo {
    WDUTContextInfo *context = [WDUTContextInfo instance];
    
    NSMutableDictionary *commonInfoDict = [NSMutableDictionary dictionary];
    
    //steady Info
    NSDictionary *steadyInfo = [context.steadyContextInfo copy];
    if (steadyInfo.count > 0) {
        [commonInfoDict addEntriesFromDictionary:steadyInfo];
    }

    /// 设备相关通用信息
    [commonInfoDict wdutSetObject:context.currentNetworkString forKey:WDUT_EVENT_FIELD_ACCESS];
    [commonInfoDict wdutSetObject:context.currentCarrierString forKey:WDUT_EVENT_FIELD_CARRIER];
    [commonInfoDict wdutSetObject:context.currentIpString forKey:WDUT_EVENT_FIELD_CLIENTIP];
    [commonInfoDict wdutSetObject:context.cuid forKey:WDUT_EVENT_FIELD_DEVICEID];
    [commonInfoDict wdutSetObject:context.cuid forKey:WDUT_EVENT_FIELD_CUID];
    [commonInfoDict wdutSetObject:[WDUTContextInfo suid] forKey:WDUT_EVENT_FIELD_SUID];

    //用户信息
    // 原先这两个字端是重复的，不知道有什么用
    [commonInfoDict wdutSetObject:context.userId forKey:WDUT_EVENT_FIELD_BUYERID];
    [commonInfoDict wdutSetObject:context.userId forKey:WDUT_EVENT_FIELD_USERID];
    [commonInfoDict wdutSetObject:context.formatUserId forKey:WDUT_EVENT_FIELD_FORMAT_USERID];
    [commonInfoDict wdutSetObject:context.shopId forKey:WDUT_EVENT_FIELD_SHOPID];
    [commonInfoDict wdutSetObject:context.phoneNumber forKey:WDUT_EVENT_FIELD_PHONE_NUMBER];

    //新增
    [commonInfoDict wdutSetObject:[WDUTLocationManager sharedInstance].latitude forKey:WDUT_EVENT_FIELD_LATITUDE];
    [commonInfoDict wdutSetObject:[WDUTLocationManager sharedInstance].longitude forKey:WDUT_EVENT_FIELD_LONGITUDE];

    /// app配置相关通用信息
    [commonInfoDict wdutSetObject:[WDUTConfig instance].appKey forKey:WDUT_EVENT_FIELD_APP_KEY];
    [commonInfoDict wdutSetObject:context.channel forKey:WDUT_EVENT_FIELD_CHANNEL];
    [commonInfoDict wdutSetObject:[WDUTContextInfo appVersion] forKey:WDUT_EVENT_FIELD_APP_VERSION];
    
    //风控需求
    [commonInfoDict wdutSetObject:[WDUTContextInfo isViaProxy] forKey:WDUT_EVENT_FIELD_PROXY];

    return commonInfoDict;
}

#pragma mark - internal func.

+ (NSString *)getUUID {
    CFUUIDRef uid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uid));
    CFRelease(uid);
    return uidString;
}

@end

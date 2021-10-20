//
//  WDNDeviceInfoUtil.h
//  Pods
//
//  Created by yangxin02 on 15/10/29.
//
//

#import <Foundation/Foundation.h>

extern NSString * const WDNetWorkStatusChangeNOTIFICATION;

typedef NS_ENUM(NSInteger, WDNStatus) {
    WDNStatusNo = 1,
    WDNStatusWIFI = 2,
    WDNStatusMobile = 3,
    WDNStatus4G = 4,
    WDNStatus3G = 5,
    WDNStatus2G = 6,
};

typedef NS_ENUM(NSInteger, WDNStatusChange) {
    WDNStatusNoChange = 0,
    WDNStatusNo2Mobile,
    WDNStatusWifi2Mobile,
    WDNStatusWifi2No,
    WDNStatusMobile2No,
    WDNStatusNo2Wifi,
    WDNStatusMobile2Wifi,
};

typedef NS_ENUM(NSInteger, WDNCellular) {
    WDNCellularMobile = 1,  //中国移动
    WDNCellularUnicom = 2,      //中国联通
    WDNCellularTelecom = 3,     //中国电信
    WDNCellularTietong = 4,     //中国铁通
    WDNCellularOther = 5,
};


@class CLLocation;

@interface WDNDeviceInfoUtil : NSObject

@property (nonatomic, assign, readonly) WDNCellular cellular;
@property (nonatomic, strong, readonly) NSString *cellularNetType;

@property (nonatomic, assign, readonly) WDNStatus currentNetStatus;
@property (nonatomic, assign, readonly) WDNStatus currentGeneralNetStatus;
@property (nonatomic, strong, readonly) NSString *currentNetString;

@property (nonatomic, strong, readonly) NSString *appRunningStatus;

// 空值，VDHttpDNS使用（VDHttpDNS处于关闭状态）
@property (nonatomic, copy) NSString *openUDID;

//保持不变的数据
@property (nonatomic, strong, readonly) NSString *openVDUDID;
@property (nonatomic, strong, readonly) NSString *suid;
@property (nonatomic, strong, readonly) NSString *uuid;
@property (nonatomic, strong, readonly) NSString *kdChainid;
@property (nonatomic, strong, readonly) NSString *deviceName;
@property (nonatomic, strong, readonly) NSString *machineName;
@property (nonatomic, strong, readonly) NSString *mid;
@property (nonatomic, strong, readonly) NSString *w;
@property (nonatomic, strong, readonly) NSString *h;
@property (nonatomic, strong, readonly) NSString *os;
@property (nonatomic, strong, readonly) NSString *platform;
@property (nonatomic, strong, readonly) NSString *appVersion;
@property (nonatomic, strong, readonly) NSString *buildTime;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (instancetype)shareUtil;
+ (NSString *)appRunningStatus;

- (void)startLocation;
- (void)stopLocation;


/// 单位是G
- (NSUInteger)ramSize;

@end

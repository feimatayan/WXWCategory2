//
//  GLDeviceInfo.h
//  iShoppingCommon
//
//  Created by 一山 赵 on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// imei, iOS 已经取不出
NSString* imei();

// imsi, iOS 已经取不出
NSString* imsi();

// mac, iOS 已经取不出
NSString* macAddress();

// 取APP的CFBundleShortVersionString
NSString* appVersion();

// 取APP的CFBundleIdentifier字段对应值
NSString* appBundleIdentifier();

//本地写死：cn.geili.IShopping2，，保留只是兼容之前处理
NSString* appBundleIdentifierConst();   //本地写死：cn.geili.IShopping2

//push statistics  NSUserDefault中对应的DEVICETOKEN对应的值
void addDeviceToken(NSData *token);
NSString* getDevicePushToken();

// 不再使用，保留只是兼容之前处理
NSString* getKeyChainID();

// 获取系统CFUUIDCreateString，保存在keychain和NSUserDefaults。
NSString* getOpenID();

//////////////////////////
// 网络请求信息，brand，openudid，idfv，machineName,idfa,open_id,mid,w,h,imei,imsi,os,mac,platform,version，build，wmac,wssid，bundleid
NSMutableDictionary* getStaticDeviceInfo();

// 打包时间
NSString* compileDateString();

// NSData转换为16进制字符串
NSString* convertToHexString(NSData* data);

// 获取手机mid，设备名称，例如：“某某的iPhone”。
NSString* getMid();

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

@interface GLDeviceInfo : NSObject

// 取APP的CFBundleShortVersionString
+ (NSString *)appVersion;

// 取APP的CFBundleIdentifier字段对应值
+ (NSString *)appBundleIdentifier;

//本地写死：cn.geili.IShopping2，，保留只是兼容之前处理
+ (NSString *)appBundleIdentifierConst;

//push statistics  NSUserDefault中对应的DEVICETOKEN对应的值
+ (void)addDeviceToken:(NSData *)token;
+ (NSString *)getDevicePushToken;

// 不再使用，保留只是兼容之前处理
+ (NSString *)getKeyChainID;

// 获取系统CFUUIDCreateString，保存在keychain和NSUserDefaults。
+ (NSString *)getOpenID;

// 网络请求信息，brand，openudid，idfv，machineName,idfa,open_id,mid,w,h,os,platform,version，build，wmac,wssid，bundleid
+ (NSMutableDictionary *)getStaticDeviceInfo;

// 打包时间
+ (NSString *)compileDateString;

// NSData转换为16进制字符串
+ (NSString *)convertToHexString:(NSData *)data;

//设备厂商信息,Apple
+ (NSString *)brand;

//设备屏幕宽度
+ (NSNumber *)screenWidth;

//设备屏幕高度
+ (NSNumber *)screenHeight;

//系统固件版本
+ (NSString *)systemVersion;

//设备具体型号信息，据此判断配件类型
+ (NSString *)deviceModel;

//编译时间，精确到秒
+ (NSString *)buildDate;

//路由器ssid
+ (NSString *)wssid;

//路由器mac
+ (NSString *)wmac;

//设备平台，例如：iPhone,iPad
+ (NSString *)platform;

//app版本号
+ (NSString *)version;

//取值identifierForVender（统一广告主标识符）,替换uuid变量名，为了概念清晰
+ (NSString *)idfv;

//仅ios平台赋值，取值advertisingForIdentifier（广告标识符），其他平台置空
+ (NSString *)idfa;

//开源项目提供的唯一标识符，用于替换原生的udid
+ (NSString *)openUDID;

//程序只要创建一次CFUUIDRef值，除非被删除，要不然将永远保存手机，间接做为设备的唯一标识。做法：新的CFUUIDRef值，将在NSUserDefaults, Keychain各存一份，程序覆盖安装可以从NSUserDefaults取，删除重新下载可以从Keychain取，然后同步到NSUserDefaults。尽最大可能保证已有的CFUUIDRef值不变
+ (NSString *)openID;

//苹果apns服务对错误bundle下token不报错，但是会阻碍后续token的push下发。为了解决这个问题，我们将token和bundleid捆绑配对
+ (NSString *)bundleID;

//设备名称
+ (NSString *)machineName;

//运营商国家代码
+ (NSString *)mcc;

//运营商网络代码
+ (NSString *)mnc;

// 获取手机mid，设备名称，例如：“某某的iPhone”。
+ (NSString *)mid;

@end

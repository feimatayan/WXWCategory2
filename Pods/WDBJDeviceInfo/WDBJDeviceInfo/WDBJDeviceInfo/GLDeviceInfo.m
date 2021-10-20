//
//  GLDeviceInfo.m
//  iShoppingCommon
//
//  Created by 一山 赵 on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GLDeviceInfo.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "OpenUDID.h"
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static NSString *kBrand = @"Apple";
static CTTelephonyNetworkInfo *teleInfo;


NSString* const DEVICETOKEN = @"DEVICETOKEN";
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
//http parameter information
NSString* macAddress() {
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
#ifdef DEBUG
        NSLog(@"macAddress Error: %@", errorFlag);
#endif
        errorFlag = @"00:00:00:00:00:00";
        
        if( msgBuffer ) {
            free(msgBuffer);
        }
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

NSDictionary *fetchSSIDInfo()
{
    NSDictionary *SSIDInfo = nil;
    //    if ([[UIDevice currentDevice].systemVersion doubleValue] <= 9.0) {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

NSString* imei() {
    return  @"";
    //    NSString* srcID = nil;
    //    srcID = MD5KeyFromStrURL(macAddress()) ;
    //    srcID = [OpenUDID value];
    //
    //    NSString* imei = [srcID substringToIndex:15];
    ////    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)]) {
    ////        if ([[[UIDevice currentDevice] uniqueIdentifier] length] > 15) {
    ////            imei = [[[UIDevice currentDevice] uniqueIdentifier] substringToIndex:15];
    ////        }
    ////    }
    //
    //    return imei;
}


NSString* imsi() {
    return  @"";
    //
    //    NSString* srcID = nil;
    //    srcID = MD5KeyFromStrURL(macAddress()) ;
    //    srcID = [OpenUDID value];
    //    NSString* imsi = [srcID substringFromIndex:15];
    ////    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)]) {
    ////        int udidlen = [[[UIDevice currentDevice] uniqueIdentifier] length];
    ////        if (udidlen > 15) {
    ////            imsi = [[[UIDevice currentDevice] uniqueIdentifier] substringFromIndex:(udidlen - 15)];
    ////        }
    ////    }
    //
    //    return imsi;
}


#pragma -mark  - push statistics
//push infor
void addDeviceToken(NSData *token)
{
    if( token ) {
        NSString* hexString = convertToHexString(token);
        [[NSUserDefaults standardUserDefaults] setObject:hexString forKey:DEVICETOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

NSString* getDevicePushToken() {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN];
}

NSMutableDictionary * getKeychainQuery(NSString * key)
{
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          (id)kSecClassGenericPassword,(id)kSecClass,
                                          key, (id)kSecAttrService,
                                          key, (id)kSecAttrAccount,
                                          (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
                                          nil];
    return keychainQuery;
}

BOOL saveToKeychain(id data, id key)
{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = getKeychainQuery(key);
    
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    return (status == noErr);
}

id loadDataFromKeychainForKey(NSString *key)
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = getKeychainQuery(key);
    
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            //            NSLog(@"load data for key '%@' failed: %@", key, e);
        } @finally {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

void removeDataFromKeychainForKey(NSString *key)
{
    NSMutableDictionary *keychainQuery = getKeychainQuery(key);
    SecItemDelete((CFDictionaryRef)keychainQuery);
}



NSString* getKeyChainID()
{
    static NSString * strUUID = nil;
    
    if (strUUID && strUUID.length > 0) {
        return strUUID;
    }
    
    @synchronized (@"koudai.weidian.uuid") {
        if (!strUUID || strUUID.length == 0) {
            NSString *uuidKey = @"koudai.weidian.uuid";
            strUUID = loadDataFromKeychainForKey(uuidKey);
            if (strUUID && [strUUID isKindOfClass:[NSString class]] && strUUID.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:uuidKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                strUUID = [[NSUserDefaults standardUserDefaults] objectForKey:uuidKey];
                if (strUUID && [strUUID isKindOfClass:[NSString class]] && strUUID.length > 0) {
                    saveToKeychain(strUUID, uuidKey);
                } else {
                    //生成一个uuid的方法
                    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
                    CFStringRef ref = CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
                    strUUID = (NSString *)CFBridgingRelease(ref);
                    
                    CFRelease(uuidRef);
                    
                    //将该uuid保存到keychain
                    if (!strUUID) {
                        strUUID = @"";
                    }
                    
                    saveToKeychain(strUUID,uuidKey);
                    [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:uuidKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }
    
    return strUUID;
    
}

NSString* getOpenID()
{
    return getKeyChainID();
}


#pragma -mark  - device statistics
NSString* appVersion()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
}

NSString* appBundleIdentifier()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] ;
}

NSString* appBundleIdentifierConst()
{
    return @"cn.geili.IShopping2";
}


NSString* machineName()
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    if (size > 0 ) {
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *deviceName = [NSString stringWithUTF8String:machine];
        free(machine);
        
        return deviceName;
    }
    return @"";
}

NSMutableDictionary* getStaticDeviceInfo()
{
    //statistic infor
    NSMutableDictionary* dicItem = [[NSMutableDictionary alloc] initWithCapacity:15];
    [dicItem setObject:kBrand forKey:@"brand"];
    
    [dicItem setObject:[OpenUDID value] forKey:@"openudid"];
    
    // idfv
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString* idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [dicItem setObject: (idfv ? idfv:@"") forKey:@"idfv"];
    } else {
        [dicItem setObject: @"" forKey:@"idfv"];
    }
    
    [dicItem setObject:machineName() forKey:@"machineName"];
    
    NSString* uuid = @"";
    float ver=[[[UIDevice currentDevice] systemVersion] floatValue];
    if ( ver>= 6.0 ){
        uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        uuid = (uuid ? uuid:@"");
    }
    [dicItem setObject:uuid forKey:@"idfa"];
    
    // open_id
    [dicItem setObject:getKeyChainID() forKey:@"open_id"];
    
    // mid
    [dicItem setObject:getMid() forKey:@"mid"];
    
    //mid_analysis
    [dicItem setObject:machineName() forKey:@"mid_analysis"];
    
    // screenSize w and h
    CGSize screenSize = [[[UIScreen mainScreen] currentMode] size];
    [dicItem setObject:[NSString stringWithFormat:@"%d", (int)screenSize.width] forKey:@"w"];
    [dicItem setObject:[NSString stringWithFormat:@"%d", (int)screenSize.height] forKey:@"h"];
    
    // imei
//    [dicItem setObject:imei() forKey:@"imei"];
    // imsi
//    [dicItem setObject:imsi() forKey:@"imsi"];
    // OS
    [dicItem setObject:[[UIDevice currentDevice] systemVersion] forKey:@"os"];
    // mac地址
    [dicItem setObject:macAddress() forKey:@"mac"];
    
    // platform
    if( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ) {
        [dicItem setObject:@"ipad" forKey:@"platform"];
    } else {
        [dicItem setObject:@"iphone" forKey:@"platform"];
    }
    // version
    [dicItem setObject:appVersion() forKey:@"version"];
    
    // build timestamp
    NSString *bt = compileDateString();
    if (bt.length > 0) {
        [dicItem setObject:compileDateString() forKey:@"build"];
    } else {
        [dicItem setObject:@"" forKey:@"build"];
    }
    
    // 添加使用wifi的mac及ssid
    NSDictionary * dict = fetchSSIDInfo();
    if (dict) {
        if ([dict objectForKey:@"BSSID"]) {
            [dicItem setObject:[dict objectForKey:@"BSSID"] forKey:@"wmac"];
        } else {
            [dicItem setObject:@"" forKey:@"wmac"];
        }
        if ([dict objectForKey:@"SSID"]) {
            [dicItem setObject:[dict objectForKey:@"SSID"] forKey:@"wssid"];
        } else {
            [dicItem setObject:@"" forKey:@"wssid"];
        }
    } else {
        [dicItem setObject:@"" forKey:@"wmac"];
        [dicItem setObject:@"" forKey:@"wssid"];
    }
    
    // bundleid
    [dicItem setObject:appBundleIdentifier() forKey:@"bundleid"];
    
    return dicItem;
}

NSString* convertToHexString(NSData* data)
{
    NSInteger length = [data length];
    unsigned char *buffer = (unsigned char*)[data bytes];
    NSMutableString* hexString = [[NSMutableString alloc] initWithCapacity:length*2];
    for (int ii = 0; ii < length; ++ii)
    {
        [hexString appendFormat:@"%02x", buffer[ii], nil];
    }
    return hexString;
}

NSString* compileDateString()
{
    static NSString* compileDateStr = nil;
    if( nil == compileDateStr ) {
        NSString* pstr = [NSString stringWithCString:__DATE__ encoding:NSASCIIStringEncoding];
        NSString* strTime = [NSString stringWithCString:__TIME__ encoding:NSASCIIStringEncoding];
        pstr = [NSString stringWithFormat:@"%@ %@", pstr, strTime];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        [dateFormatter setDateFormat:@"MM dd yyyy HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:pstr];
        
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        compileDateStr = [dateFormatter stringFromDate:date];
        if( nil == compileDateStr ) {
            compileDateStr = pstr;
        }
        if( nil == compileDateStr ) {
            compileDateStr = @"";
        }
    }
    
    return compileDateStr ? compileDateStr: @"";
}

// 获取手机mid，设备名称，例如：“某某的iPhone”。
NSString* getMid() {
    return [UIDevice currentDevice].name;
}

#pragma mark - 新增的OC方法

@implementation GLDeviceInfo

+ (NSString *)brand{
    return kBrand;
}

+ (NSNumber *)screenWidth{
    return @([[[UIScreen mainScreen] currentMode] size].width);
}

+ (NSNumber *)screenHeight{
    return @([[[UIScreen mainScreen] currentMode] size].height);
}

+ (NSString *)systemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)deviceModel{
    return [[UIDevice currentDevice] localizedModel];
}

+ (NSString *)buildDate{
    return [self compileDateString];
}

+ (NSString *)compileDateString{
    return compileDateString();
}

+ (NSString *)wssid{
    NSDictionary * dict = fetchSSIDInfo();
    NSString *ssid = @"";
    if (dict) {
        if ([dict objectForKey:@"SSID"]) {
            ssid = [dict objectForKey:@"SSID"];
        }
    }
    return ssid;
}

+ (NSString *)wmac{
    NSDictionary * dict = fetchSSIDInfo();
    NSString *ssid = @"";
    if (dict) {
        if ([dict objectForKey:@"BSSID"]) {
            ssid = [dict objectForKey:@"BSSID"];
        }
    }
    return ssid;
}

+ (NSString *)platform{
    NSString *platForm = @"iphone";
    if( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ) {
        platForm = @"ipad";
    }
    return platForm;
}

+ (NSString *)version{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)idfa{
    NSString *uuid;
    uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    uuid = (uuid.length > 0 ? uuid:@"");
    return uuid;
}

+ (NSString *)idfv{
    NSString *idfvStr = @"";
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString* idfvTemp = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        idfvStr = (idfvTemp.length > 0 ? idfvTemp:@"");
    }
    return idfvStr;
}

+ (NSString *)openUDID{
    return [OpenUDID value];
}

+ (NSString *)openID{
    return getKeyChainID();
}

+ (NSString *)bundleID{
    return appBundleIdentifier();
}

+ (NSString *)machineName{
    return machineName();
}

+ (NSString *)mcc{
    
    if (!teleInfo) {
        @synchronized (self) {
            if (!teleInfo) {
                teleInfo = [[CTTelephonyNetworkInfo alloc] init];
            }
        }
    }
    
    CTCarrier *carrier = [teleInfo subscriberCellularProvider];
    
    NSString *mccInfo = [carrier mobileCountryCode];
    
    return mccInfo;
}

+ (NSString *)mnc{
    
    if (!teleInfo) {
        @synchronized (self) {
            if (!teleInfo) {
                teleInfo = [[CTTelephonyNetworkInfo alloc] init];
            }
        }
    }
    
    CTCarrier *carrier = [teleInfo subscriberCellularProvider];
    
    NSString *mncInfo = [carrier mobileNetworkCode];
    
    return mncInfo;
}

+ (NSString *)appVersion{
    return appVersion();
}

+ (NSString *)appBundleIdentifier{
    return appBundleIdentifier();
}

+ (NSString *)appBundleIdentifierConst{
    return appBundleIdentifierConst();
}

+ (NSMutableDictionary *)getStaticDeviceInfo{
    
    NSMutableDictionary *deviceInfoDic = [[NSMutableDictionary alloc] initWithCapacity:19];
    
    //brand
    [deviceInfoDic setObject:kBrand forKey:@"brand"];
    
    // mac地址
    [deviceInfoDic setObject:@"" forKey:@"mac"];
    
    // screenSize w and h
    [deviceInfoDic setObject:[self screenWidth] forKey:@"w"];
    [deviceInfoDic setObject:[self screenHeight] forKey:@"h"];
    
    // OS
    [deviceInfoDic setObject:[self systemVersion] forKey:@"os"];
    
    // mid
    [deviceInfoDic setObject:[self mid] forKey:@"mid"];
    
    //mid_analysis
    [deviceInfoDic setObject:[self machineName] forKey:@"mid_analysis"];
    
    // build timestamp
    [deviceInfoDic setObject:[self compileDateString] forKey:@"build"];
    
    // 添加使用wifi的mac及ssid
    [deviceInfoDic setObject:[self wssid] forKey:@"wssid"];
    [deviceInfoDic setObject:[self wmac] forKey:@"wmac"];
    
    // platform
    [deviceInfoDic setObject:[self platform] forKey:@"platform"];
    
    // version
    [deviceInfoDic setObject:[self appVersion] forKey:@"version"];
    
    // imei
//    [deviceInfoDic setObject:@"" forKey:@"imei"];
    
    // imsi
//    [deviceInfoDic setObject:@"" forKey:@"imsi"];
    
    // idfv
    [deviceInfoDic setObject: [self idfv] forKey:@"idfv"];
    
    //idfa
    [deviceInfoDic setObject:[self idfa] forKey:@"idfa"];
    
    //openUDID
    [deviceInfoDic setObject:[self openUDID] forKey:@"openudid"];
    
    // open_id
    [deviceInfoDic setObject:[self getOpenID] forKey:@"open_id"];
    
    // bundleid
    [deviceInfoDic setObject:[self appBundleIdentifier] forKey:@"bundleid"];
    
    //machineName
    [deviceInfoDic setObject:[self machineName] forKey:@"machineName"];
    
    return deviceInfoDic;

}

+ (NSString *)getOpenID{
    return getOpenID();
}

+ (NSString *)getKeyChainID{
    return getKeyChainID();
}

+ (NSString *)getDevicePushToken{
    return getDevicePushToken();
}

+ (void)addDeviceToken:(NSData *)token{
    addDeviceToken(token);
}

+ (NSString *)convertToHexString:(NSData *)data{
    return convertToHexString(data);
}


+ (NSString *)mid{
    return [UIDevice currentDevice].name;
}

@end

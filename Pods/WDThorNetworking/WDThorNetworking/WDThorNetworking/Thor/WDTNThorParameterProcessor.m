//
//  WDTNThorParameterProcessor.m
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/9/27.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import "WDTNThorParameterProcessor.h"
#import "WDTNRequestConfig.h"
#import "WDTNPerformTask.h"
#import "WDTNNetwrokConfig.h"
#import "WDTNUtils.h"
#import "WDTNUT.h"
#import "WDTNLog.h"
#import "WDTNNetwrokErrorDefine.h"
#import "WDTNServerClockProofreader.h"
#import "WDTNThorProtocolImp.h"
#import "WDTNAccountDO.h"
#import "WDTNThorAES.h"
#import "WDTNThorGZip.h"

#import <WDBJEncryptUtil/WDBJEncryptUtil.h>
#import <WDBJDeviceInfo/WDBJDeviceInfo.h>


@implementation WDTNThorParameterProcessor

static NSMutableDictionary *_cachedConfigHeaders = nil;

/**
 一种config对应一种header.
 */
+ (NSDictionary *)HTTPHeaderFields:(WDTNRequestConfig *)config {
    if (_cachedConfigHeaders == nil) {
        _cachedConfigHeaders = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *header = _cachedConfigHeaders[config.configType];
    if (header == nil) {
        header = [NSMutableDictionary dictionary];
        
        // UA
        header[@"user-agent"] = [WDTNThorProtocolImp thorUserAgent];
        
        header[@"content-type"] = @"application/x-www-form-urlencoded";
        header[@"x-origin"] = @"thor";
        header[@"referrer"] = @"https://ios.weidian.com";
        header[@"referer"] = @"https://ios.weidian.com";
        header[@"origin"] = @"ios.weidian.com";
        
        header[@"x-schema"] = @"https";
        // 期望响应加密, 压缩
        header[@"x-encrypt"] = @"1";
        header[@"accept-encoding"] = @"GLZip";
        
        // cache
        _cachedConfigHeaders[config.configType] = header;
    }
   
    if ([WDTNNetwrokConfig sharedInstance].isDebugModel) {
        header[@"x-schema"] = (config.reqEncryStatus == 0) ? @"http" : @"https";
        // 期望响应加密, 压缩
        header[@"x-encrypt"] = (config.reqEncryStatus == 0) ? @"0" : @"1";
        header[@"accept-encoding"] = @"identity";
    }
    
    return header;
}


+ (NSData *)HTTPBody:(id)jsonParam task:(WDTNPerformTask *)task error:(NSError **)error {
    // context
    NSDictionary *context = [[self class] thorContext:task];

    // 签名，组装payload
    NSString *payload = [WDTNThorProtocolImp thorPayloadWithContext:context
                                                              param:jsonParam
                                                          forConfig:task.config];
    
    task.publicParams = @{@"context": context ?: @{},
                          @"param": jsonParam ?: @{},
                          @"payload": payload ?: @""}; // 用于日志打印
    
    if (payload == nil) { // 组装失败，生成错误
        if (error != NULL) {
            *error = [NSError errorWithDomain:WDTNError_JsonParse_failed_domain code:WDTNError_JsonParse_failed userInfo:nil];
        }
        
        return nil;
    } else {
        return [payload dataUsingEncoding:NSUTF8StringEncoding];
    }
}


#pragma mark - privite methods

static NSDictionary* _deviceInfo = nil;

/**
 brand = Apple;
 build = 20170321152828;
 bundleid = "Weidian.WDThorNetworkingDemo";
 h = 1334;
 idfa = "C00F2C1B-88E9-4344-9A45-42BF16F151A4";
 idfv = "F2E84B06-1AAA-479C-AA96-E1CE6E2BB9A8";
 mac = "";
 machineName = "x86_64";
 mid = iPhone;
 open_id = "701CB5C4-6EEF-4D8B-9CE9-DF1070A266E2";
 openudid = 4f66c3dfcafcbfd978f983e591c076180ae58f89;
 os = "10.3.1";
 platform = iphone;
 version = "1.0";
 w = 750;
 wmac = "";
 wssid = "";
 
 @return 设备常规信息，不会变化
 */
+ (NSDictionary*)deviceInfo:(WDTNPerformTask *)task {
    if (_deviceInfo == nil) {
//        id<WDTNStaticHeaderOnSceneDelegate> sceneDelegate = [WDTNNetwrokConfig sharedInstance].staticHeaderDelegate;
        id<WDTNStaticHeaderOnSceneDelegate> sceneDelegate = task.config.staticHeaderDelegate;
        if (sceneDelegate != nil) {
            _deviceInfo = [sceneDelegate staticDeviceInfo];
        } else {

            _deviceInfo = [GLDeviceInfo getStaticDeviceInfo];
        }
    }
    
    return _deviceInfo;
}


/**
 access_token = "AAAAAeOtRH5m2CgbSE0C2C4H+T0Wb6JfU7lr51GLLVajHJa17hHZmFDAaZViOt0e/LxtQRKqJjhp4p/LojNxJSIaWPu68WjC3ft+UXfZ6y5OryoNygLoYw8x1/Ga1VUI2XWZWr9ZXD4rleEer9amVlUBkPg.";
 aes_key = "4b226cb2649d274d1be2f96c2766b8e5"
 apiv = 820;
 app_code" = WD;
 app_key = 23471650;
 app_secret = 348387574c864a5ba492e36991cb6b6c;
 appid = "com.koudai.weishop";
 appstatus = other;
 build = 20170321152828;
 channel = 1000f;
 device_id = 127218839;
 device_id_v2 = "6da8eb0b3f330c99b98f82dc15a600ed+41770a988041f7af1c57cf16b6302ba8";
 Logguid = "1506497744855_4360473";
 network = WIFI;
 sessionid = "userID = 721257179;
 wduss = 46cf3515e4f6be6b35d08f421d8bab69b1629e3dc4d21bb27206723966bec06ad8b6fef19ebc7ff124c50f0cb9a529bb;
 
 @return app业务相关参数, userID等可能变化，需要每次获取，获取效率可能低
 */
+ (NSDictionary*)appParams:(WDTNPerformTask *)task {
//    id<WDTNVarHeaderOnSceneDelegate> varParamsDel = [WDTNNetwrokConfig sharedInstance].varHeaderDelegate;
    id<WDTNVarHeaderOnSceneDelegate> varParamsDel = task.config.varHeaderDelegate;
    NSDictionary* varParams = nil;
    @synchronized (varParamsDel) { //增加delegate方法varHeaderItemOnScene的线程安全
        varParams = [[varParamsDel varHeaderItemOnScene] copy];
    }
    
    return varParams;
}

+ (NSDictionary*)thorContext:(WDTNPerformTask *)task {
    NSDictionary* appParams = [[self class] appParams:task];
    
    NSDictionary* deviceInfo = [[self class] deviceInfo:task];
    
    NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:30];

    // 设备维度参数
    context[@"platform"] = [WDTNUtils safeString:deviceInfo[@"platform"]];
    context[@"brand"] = [WDTNUtils safeString:deviceInfo[@"brand"]];
    context[@"machine_model"] = [WDTNUtils safeString:deviceInfo[@"machineName"]]; // 兼容老协议配置
    context[@"mac"] = [WDTNUtils safeString:deviceInfo[@"mac"]];
    context[@"w"] = [WDTNUtils safeString:deviceInfo[@"w"]];
    context[@"h"] = [WDTNUtils safeString:deviceInfo[@"h"]];
    context[@"os"] = [WDTNUtils safeString:deviceInfo[@"os"]];
    context[@"mid"] = [WDTNUtils safeString:deviceInfo[@"mid"]];
    context[@"wssid"] = [WDTNUtils safeString:deviceInfo[@"wssid"]];
    context[@"wmac"] = [WDTNUtils safeString:deviceInfo[@"wmac"]];
    
    context[@"idfa"] = [WDTNUtils safeString:deviceInfo[@"idfa"]];
    NSString *idfa = [WDTNUtils safeString:appParams[@"idfa"]];
    if (idfa.length > 0) {
        context[@"idfa"] = idfa;
    }
    
    context[@"idfv"] = [WDTNUtils safeString:deviceInfo[@"idfv"]];
    
    NSString *cuid = [WDTNUtils safeString:appParams[@"cuid"]];
    context[@"cuid"] = cuid;
    if (cuid.length == 0) {
        context[@"cuid"] = [WDTNUT getCuid];
    }
    
    NSString *suid = [WDTNUtils safeString:appParams[@"suid"]];
    context[@"suid"] = suid;
    if (suid.length == 0) {
        context[@"suid"] = [WDTNUT getSuid];
    }
    
    NSString *duid = appParams[@"duid"];
    if (duid.length == 0) {
        duid = [WDTNNetwrokConfig sharedInstance].account.duid;
    }
    context[@"duid"] = [WDTNUtils safeString:duid];
    
    // 微店账号体系维度
    NSString *buyUid = appParams[@"buy_uid"];
    if (buyUid) {
        context[@"uid"] = [WDTNUtils safeString:buyUid];
    } else {
        // 兼容老协议配置
        context[@"uid"] = [WDTNUtils safeString:appParams[@"uid"]];
    }
    
    context[@"shop_id"] = [WDTNUtils safeString:appParams[@"shop_id"]];
    
    NSString *loginToken = appParams[@"login_token"];
    if (loginToken) {
        context[@"login_token"] = [WDTNUtils safeString:loginToken];
    } else {
        // 兼容老协议配置
        context[@"login_token"] = [WDTNUtils safeString:appParams[@"access_token"]];
    }

    // App维度参数
    NSString *appID = [WDTNUtils safeString:appParams[@"appid"]];
    if ([appID length] > 0) {
        context[@"appid"] = appID;
    } else {
        context[@"appid"] = [GLDeviceInfo appBundleIdentifier];
    }

    context[@"appv"] = [GLDeviceInfo appVersion];
    context[@"build"] = [WDTNUtils safeString:appParams[@"build"]];
    context[@"channel"] = [WDTNUtils safeString:appParams[@"channel"]];
    context[@"lon"] = [WDTNUtils safeString:appParams[@"lon"]];
    context[@"alt"] = [WDTNUtils safeString:appParams[@"alt"]];
    context[@"lat"] = [WDTNUtils safeString:appParams[@"lat"]];
    
    // 当前运行状态
    context[@"app_status"] = [WDTNUtils safeString:appParams[@"appstatus"]];
    
    // 当前网络状态
    NSString *networkStatus = [WDTNThorParameterProcessor network];
    context[@"network"] = networkStatus;
    if ([networkStatus isEqualToString:@"WIFI"]
        || [networkStatus isEqualToString:@"UNKNOWN"]
        || [networkStatus isEqualToString:@"NoNetwork"]) {
        context[@"netsubtype"] = @"";
    } else {
        NSString *accessTechnology = [self currentRadioAccessTechnology];
        context[@"netsubtype"] = accessTechnology ?: @"";
    }
    
    // iOS暂时取不到但是被标为必选的信息
    context[@"disk_capacity"] = @"";
    context[@"memory"] = @"";
    
    return context;
}


#pragma mark -


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

+ (NSDictionary *)requestThorBodyWithParse:(NSURLRequest*)request {
    static NSDictionary* WDTNThorAESMapForAppkey = nil;
    if( nil == WDTNThorAESMapForAppkey) {
        WDTNThorAESMapForAppkey = @{
        @"23471650":@"4b226cb2649d274d1be2f96c2766b8e5",
        @"45960732":@"0e9a6641c6adf451a742c98132341b91",
        @"29360457":@"6779069953073a7bc9d8c6805626e1a7",
        };
    };
    NSData* body = request.HTTPBody;
    if (body) {
//        NSString *payload = [NSString stringWithFormat:@"appkey=%@&context=%@&param=%@&timestamp=%@&v=%@&sign=%@",
//        [appKey urlEncode], [contextIM urlEncode], [paramIM urlEncode], timestamp, [v urlEncode], [sign urlEncode]];
        NSString* payload = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
        NSCharacterSet *aCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSArray *arrParam = [payload componentsSeparatedByCharactersInSet:aCharacterSet];
        aCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:50];
        [arrParam enumerateObjectsUsingBlock:^(NSString*  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *paramItem = [item componentsSeparatedByCharactersInSet:aCharacterSet];
            if (paramItem.count >= 2) {
                NSString* paramValue = paramItem[1];
                [params setObject:[paramValue urlDecode] forKey:paramItem[0]];
            }
        }];
       
        NSString *appKey = params[@"appkey"];
        if (appKey.length > 0) { // 需要加密param
            NSString *thorAesKey = WDTNThorAESMapForAppkey[appKey];
            if(thorAesKey.length > 0) {
                // context
                NSString *contextIM = params[@"context"];
                NSString *context = [[self class] thorRequestDecrypt:contextIM withAESKey:thorAesKey];
                if (context.length > 0) { // 需要加密context
                    params[@"context"] = context;
                }
                // thor 后端需要保证params非空，因此当没有参数时，param上传空字典
                NSString *paramIM = params[@"param"];
                NSString *param = [[self class] thorRequestDecrypt:paramIM withAESKey:thorAesKey];
                if (param.length > 0) { // 需要加密context
                    params[@"param"] = param;
                }
            }
        }
        return params;
    }
    return nil;
}

+ (NSString*)thorRequestDecrypt:(NSString*)strParam withAESKey:(NSString*)aesKey {
    
    // aes data -> base64 output
    NSData* aesData = [GLCharCodecUtil base64Decoding:strParam];
    if (aesData == nil) {
        WDTNLog(@"Error happend when decoding(base64) data %ld for thor protocol.", [strParam length]);
        return nil;
    }
    
    // gzip data -> aes data
    NSData* gzipData = [WDTNThorAES thorAESDecrypt:aesData withAESKey:aesKey];
    if (gzipData == nil) {
        WDTNLog(@"Error happend when decrypting(aes) data %ld for thor protocol.", [aesKey length]);
        return nil;
    }
    
    // utf8 data -> gzip data
    NSData* jsonData = [WDTNThorGZip gzipUncompress:gzipData];
    if (jsonData == nil) {
        WDTNLog(@"Error happend when gziping(unzip) data %ld for thor protocol.", [gzipData length]);
        return nil;
    }
    
    // json string -> utf8 data
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (jsonStr == nil) {
        WDTNLog(@"Error happend when convering input dict %@ to json data for thor protocol.", jsonData);
        return nil;
    }
    
    return jsonStr;
}

@end

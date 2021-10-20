//
//  WDNetworkDefine.h
//  WDNetwork-Base
//
//  Created by weidian2015090112 on 2018/10/20.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#ifndef WDNetworkDefine_h
#define WDNetworkDefine_h

typedef NS_ENUM(NSInteger, WDNetworkEngineMode) {
    WDNetworkEngineHZMode = 0,
    WDNetworkEngineBJMode,
};

typedef NS_ENUM(NSInteger, WDNVapEnvType) {
    WDN_Vap_Daily = 1,
    WDN_Vap_PreRelease,
    WDN_Vap_Release
};

typedef NS_ENUM(NSInteger, WDNAESKey) {
    WDN_AES_101 = 0,
    WDN_AES_171,
    WDN_AES_181,
    WDN_AES_201,
    WDN_AES_211,
    WDN_AES_221,
    WDN_AES_300,
};

#endif /* WDNetworkDefine_h */

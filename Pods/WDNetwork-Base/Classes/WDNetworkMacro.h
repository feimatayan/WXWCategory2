//
//  WDNetworkMacro.h
//  WDNetworkingDemo
//
//  Created by yangxin02 on 1/7/16.
//  Copyright © 2016 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


#define VD_HttpDNS_RE               @"VD-HttpDNS-Re"
#define VD_HttpDNS_Host             @"VD-HttpDNS-Host"
#define VD_Module                   @"VD-Module"

#define WDN_Vap_DailyHost           @"vap.gw.daily.weidian.com"
#define WDN_Vap_PreHost             @"vap.gw.pre.weidian.com"
#define WDN_Vap_ReleaseHost         @"vap.gw.weidian.com"

#define WDN_Thor_DailyHost          @"thor.daily.weidian.com"
#define WDN_Thor_PreHost            @"thor.pre.weidian.com"
#define WDN_Thor_ReleaseHost        @"thor.weidian.com"

#define WDN_VAP_CONTENT_TYPE        @"Content-Type"
#define WDN_VAP_CONTENT_TYPESTREAM  @"application/octet-stream;charset=UTF-8"
#define WDN_VAP_HEADER_GZIP         @"X-Gzip"
#define WDN_VAP_HEADER_SIGNKEY      @"X-SignKey"
#define WDN_VAP_HEADER_CHECKSUM     @"X-Checksum"

#define WDN_Media_DailyHost         @"vimg.daily.weidian.com"
#define WDN_Media_PreHost           @"vimg.pre.weidian.com"
#define WDN_Media_ReleaseHost       @"vimg.weidian.com"


#ifdef DEBUG
#define WDNLog(format,...)  NSLog(format, ##__VA_ARGS__)
#else
#define WDNLog(...)
#endif


#define WDNPropertyDeprecated(instead)  NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
#define WDNMethodDeprecated(instead)    __attribute__((deprecated(instead)))

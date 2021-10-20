//
//  WDTNVarHeaderOnSceneDelegate.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

@protocol WDTNVarHeaderOnSceneDelegate <NSObject>

/**
 返回当前app场景的信息，这些信息可能随着app的状态和场景发生变化。
 上报字段如下：
 {
 // 1.账号信息
 "userID":***,
 "wduss":***,
 "access_token":***,
 "shop_id":***,
 "device_id":***,
 "device_id_v2":***,
 
 // 2.统计字段
 "apiv":***, // proxy协议版本号
 "appid":***, // app唯一标识符
 "channel":***, // 推广渠道
 "guid":***, // 设备虚拟标识符，用于逻辑层面标定设备唯一性
 "loc":***, // wgs84ll（国际标准经纬度）；按照lng经度,lat纬度,height海拔高度的顺序拼接。格式：printf(“%f,%f,%f”, #lng,#lat,#height);
 "lon":***,
 "alt":***,
 "lat":***,
 "token":***, // 远程push的令牌，ios取值苹果apns下发的token。
 "sessionid":***, //
 
 "suid" : **** // 来自统计sdk
 "cuid" : **** // 来自统计sdk
 
 "appstatus" : "other | active | background" // UIApplication
 
 "network" : "2G | 3G | 4G | WIFI | NoNetwork | Mobile | UNKNOWN" // realreachbility获得
 "netsubtype" : "grps | cdma" // realreachbility获得
 }
 */

- (NSDictionary*)varHeaderItemOnScene;

@end


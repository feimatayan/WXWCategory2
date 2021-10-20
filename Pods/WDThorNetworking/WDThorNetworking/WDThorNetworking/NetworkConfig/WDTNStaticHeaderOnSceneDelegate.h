//
//  WDTNStaticHeaderOnSceneDelegate.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/21.
//  Copyright © 2016年 weidian. All rights reserved.
//

@protocol WDTNStaticHeaderOnSceneDelegate <NSObject>

/**
 获取设备的静态信息.
 上报字段如下：
 {
 "platform":***,
 "version":***,
 "brand":***,
 "mac":***,
 "w":***,
 "h":***,
 "os":***,
 "mid":***,
 "kdchainid":***,
 "uuid":***,
 "idfa":***,
 "openudid":***,
 "bundleid":***,
 }
 */
- (NSDictionary *)staticDeviceInfo;

@end

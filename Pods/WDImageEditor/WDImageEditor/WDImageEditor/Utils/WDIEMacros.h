//
//  WDIEMacros.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/28.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEStatisticsManager.h"

#ifndef WDIEMacros_h
#define WDIEMacros_h

#define WDIE_IS_DEVICE_IPHONE_X                       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define WDIE_IPHONE_X_STATUS_HEIGHT    [UIApplication sharedApplication].statusBarFrame.size.height

#define WDIE_IPHONE_X_TOOLBAR_HEIGHT   34

#define WDIE_STATISTICS(ID,PARAMS) [[WDIEStatisticsManager sharedManager] logWithID:ID params:PARAMS]

#endif /* WDIEMacros_h */

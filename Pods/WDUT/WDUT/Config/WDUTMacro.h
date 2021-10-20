//
//  WDUTMacro.h
//  WDUTDemo
//
//  Created by shazhou on 2018/7/18.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#ifndef WDUTMacro_h
#define WDUTMacro_h

#define kWDUTViewDidAppearNotification     @"kWDUTViewDidAppearNotification"
#define kWDUTViewDidDisappearNotification  @"kWDUTViewDidDisappearNotification"
#define kWDUTNetworkChangedNotification @"kWDUTNetworkChangedNotification"

/// 预定义好的page值
#define WDUT_PAGE_FIELD_UT                   @"Page_UT"

/// DEBUG模式下打印日志,当前行
#ifdef DEBUG
#define WDUTLog(fmt, ...) NSLog((@"WDUT:%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define WDUTLog(...)
#endif  /*WDUT_LOG_ENABLED*/

#define WDUT_SYS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#endif /* WDUTMacro_h */

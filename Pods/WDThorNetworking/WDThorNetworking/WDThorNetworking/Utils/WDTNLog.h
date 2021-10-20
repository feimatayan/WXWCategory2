//
//  WDTNLog.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/9.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 日志打印
 打印开关: [WDTNNetwrokConfig sharedInstance].isLogOn
 */
void WDTNLog(NSString *s, ...);


@class WDTNPerformTask;

@protocol WDTNLogOutputProtocol <NSObject>

- (void)logOutPutFormatedLog:(NSDictionary *)formatedlog;

@end


@interface WDTNLogger : NSObject

+ (instancetype)sharedInstance;

/**
 设置日志输出的类
 */
- (void)setExporter:(id)obj;

@end

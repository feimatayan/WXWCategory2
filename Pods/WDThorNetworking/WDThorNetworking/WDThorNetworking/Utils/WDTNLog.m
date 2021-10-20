//
//  WDTNLog.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/9.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNLog.h"
// 条件判断
#import "WDTNNetwrokConfig.h"
#import "WDTNPerformTask.h"


void WDTNLog(NSString *s, ...) {
    if ([WDTNNetwrokConfig sharedInstance].isDebugModel && [WDTNNetwrokConfig sharedInstance].isLogOn == YES) {
        if (s != nil) {
            va_list args;
            
            va_start(args, s);
            NSString *log = [[NSString alloc] initWithFormat:s arguments:args];
            NSLog(@"\n--<< Network Extension Log Start:\n\n%@\n\nNetwork Extension Log End -->>",log);
            va_end(args);
        }
    }
}


@implementation WDTNLogger

+ (instancetype)sharedInstance {
    return nil;
}

- (void)setExporter:(id)obj {
    
}

@end


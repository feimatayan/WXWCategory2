//
//  WDTNNetwrokConfig.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNNetwrokConfig.h"
#import "WDTNDefines.h"
#import "WDTNAccountDO.h"


@interface WDTNNetwrokConfig ()

@property (nonatomic) dispatch_queue_t syncQueue;

@end

@implementation WDTNNetwrokConfig
{
    __strong WDTNAccountDO *_account;
}

nesingleton_implementation(WDTNNetwrokConfig)

- (instancetype)init {
    if (self = [super init]) {
        _thorSecurityItems = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        self.syncQueue = wdtn_create_default_queue("com.weidian.WDTNNetwrokConfig.syncQueue", DISPATCH_QUEUE_PRIORITY_HIGH);
    }
    return self;
}

- (void)setAccount:(WDTNAccountDO *)account {
    dispatch_barrier_async(self.syncQueue, ^{
        _account = account ? [WDTNAccountDO CopyAccount:account] : nil;
    });
}

- (WDTNAccountDO *)account {
    __block WDTNAccountDO *tmp;
    dispatch_sync(self.syncQueue, ^{
        tmp = _account;
    });
    return tmp;
}

@end

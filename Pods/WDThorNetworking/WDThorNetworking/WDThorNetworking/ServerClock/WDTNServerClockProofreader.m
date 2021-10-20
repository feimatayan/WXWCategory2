//
//  WDTNServerClockProofreader.m
//  WDTNServerClockProject
//
//  Created by wangcheng on 2016/11/17.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNServerClockProofreader.h"
#import "WDTNPrivateDefines.h"


@interface WDTNServerClockProofreader ()

@property (nonatomic, strong) dispatch_queue_t operationQueue;

@property (nonatomic, assign) long long serverTimeMS;
@property (nonatomic, assign) long long timeOffsetMS;

@end

@implementation WDTNServerClockProofreader

nesingleton_implementation(WDTNServerClockProofreader);

- (instancetype)init {
    if (self = [super init]) {
        self.operationQueue = dispatch_queue_create("com.weidian.WDTNServerClockProofreader.operationQueue", DISPATCH_QUEUE_SERIAL);
        
        NSNumber *timeOffsetMS = [[NSUserDefaults standardUserDefaults] objectForKey:@"kWDTNTimeOffsetMS"];
        if (timeOffsetMS) {
            self.timeOffsetMS = [timeOffsetMS longLongValue];
        }
    }
    return self;
}

- (long long)currentTime:(BOOL *)isServerTime {
    __block long long time = [@([[NSDate new] timeIntervalSince1970] * 1000) longLongValue];
    dispatch_sync(_operationQueue, ^{
        if (isServerTime) {
            time += self.timeOffsetMS;
        }
    });
    
    return time;
}

- (long long)currentServerTime {
    __block long long time = [@([[NSDate new] timeIntervalSince1970] * 1000) longLongValue];
    dispatch_sync(_operationQueue, ^{
        time += self.timeOffsetMS;
    });
    
    return time;
}

- (void)updateServerTime:(long long)serverTime {
    dispatch_barrier_async(_operationQueue, ^{
        self.serverTimeMS = serverTime;
        self.timeOffsetMS = serverTime - [@([[NSDate new] timeIntervalSince1970] * 1000) longLongValue];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(self.timeOffsetMS) forKey:@"kWDTNTimeOffsetMS"];
    });
}

@end

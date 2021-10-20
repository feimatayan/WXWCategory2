//
//  WDTNPerformTask.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNPerformTask.h"

@implementation WDTNPerformTask

- (instancetype)init {
    if (self = [super init]) {
        self.responseHandlers = [[NSMutableArray alloc] init];
        
        self.reStart = NO;
    }
    return self;
}

- (void)addResponseHandler:(WDTNResponseHandler *)handler {
    if (handler) {
        [_responseHandlers addObject:handler];
    }
}

- (void)removeHandlerById:(NSString *)handlerID {
    NSUInteger index = [_responseHandlers indexOfObjectPassingTest:^BOOL(WDTNResponseHandler *handler, __unused NSUInteger idx, __unused BOOL *stop) {
        return handler.handlerID == handlerID;
    }];
    
    if (index != NSNotFound) {
        [_responseHandlers removeObjectAtIndex:index];
    }
}

@end

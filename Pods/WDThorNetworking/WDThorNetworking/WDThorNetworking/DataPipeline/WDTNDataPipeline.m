//
//  WDTNDataPipeline.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDataPipeline.h"
#import "WDTNDataProcessProtocol.h"


@interface WDTNDataPipeline ()

@property (nonatomic, strong) NSMutableArray *queue;

@end

@implementation WDTNDataPipeline

- (instancetype)init {
    if (self = [super init]) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)appendItem:(id<WDTNDataProcessProtocol>)item {
    if ([item conformsToProtocol:@protocol(WDTNDataProcessProtocol)]) {
        [_queue addObject:item];
    }
}

- (void)removeAllItems {
    [_queue removeAllObjects];
}

- (id)processData:(id)data error:(NSError **)error {
    id inoutPut = data;
    // 每一次执行的输出都作为下一次的输入
    for (id<WDTNDataProcessProtocol> handler in _queue) {
        inoutPut = [handler processData:inoutPut error:error];
        if (error != NULL && *error != nil) {
            return nil;
        }
    }
    return inoutPut;
}

@end

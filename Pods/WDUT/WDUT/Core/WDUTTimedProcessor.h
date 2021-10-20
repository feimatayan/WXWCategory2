//
// Created by shazhou on 2018/9/5.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDUTTimedProcessor : NSObject

@property (nonatomic, assign) BOOL flushing;

- (void)resetOperationQueue;

- (void)resetTimer;

- (void)start;

// 手动触发
- (void)tick;

- (void)stop;

- (void)pause;

- (void)forceSyncFromDB;

@end

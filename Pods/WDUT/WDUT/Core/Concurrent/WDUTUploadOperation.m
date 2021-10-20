//
// Created by shazhou on 2018/9/5.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTUploadOperation.h"
#import "WDUTService.h"
#import "WDUTLogModel.h"
#import "WDUTStorageManager.h"
#import "WDUTDef.h"

@interface WDUTUploadOperation()

@end

@implementation WDUTUploadOperation {
    NSArray *_logs;
}

- (id)initWithLogs:(NSArray *)logs {
    self = [super init];
    if (self) {
        _logs = logs;
    }
    return self;
}

- (void)main {
    if (self.isCancelled) {
        if (_operationCompletionBlock) {
            _operationCompletionBlock(NO, [NSError errorWithDomain:@"" code:WDUT_ERROR_REQUEST_CANCELED userInfo:nil]);
        }
        return;
    }

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [WDUTService uploadLogs:_logs complete:^(BOOL isSuccess, NSDictionary *result, NSError *error) {

        if (_operationCompletionBlock) {
            _operationCompletionBlock(isSuccess, error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end

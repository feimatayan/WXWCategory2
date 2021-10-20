//
// Created by shazhou on 2018/9/5.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDUTUploadOperation : NSOperation

@property (nonatomic, copy) void (^operationCompletionBlock)(BOOL isSuccess, NSError *error);

- (id)initWithLogs:(NSArray *)logs;

@end

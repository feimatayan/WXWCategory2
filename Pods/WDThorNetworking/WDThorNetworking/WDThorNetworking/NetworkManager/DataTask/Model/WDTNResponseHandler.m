//
//  WDTNResponseHandler.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/7.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNResponseHandler.h"

@implementation WDTNResponseHandler

- (instancetype)initWithHandlerID:(NSString *)handlerID success:(WDTNReqResSuccessBlock)successBlock failure:(WDTNReqResFailureBlock)failureBlock {
    if (self = [super init]) {
        self.handlerID = handlerID;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
    }
    return self;
}

@end

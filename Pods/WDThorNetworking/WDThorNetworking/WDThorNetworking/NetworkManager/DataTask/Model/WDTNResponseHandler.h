//
//  WDTNResponseHandler.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/7.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNDefines.h"

@interface WDTNResponseHandler : NSObject

/// 请求的url相同时，区分不同的回调函数,与controlID相同。
@property (nonatomic, strong) NSString *handlerID;
/// 保存请求成功的block
@property (nonatomic, strong) WDTNReqResSuccessBlock successBlock;
/// 保存请求失败的block
@property (nonatomic, strong) WDTNReqResFailureBlock failureBlock;

- (instancetype)initWithHandlerID:(NSString *)handlerID success:(WDTNReqResSuccessBlock)successBlock failure:(WDTNReqResFailureBlock)failureBlock;

@end

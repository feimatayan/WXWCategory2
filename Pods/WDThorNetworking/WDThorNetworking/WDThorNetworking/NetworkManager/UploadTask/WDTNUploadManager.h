//
//  WDTNUploadManager.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/15.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNMultipartFormData.h"
#import "WDTNDefines.h"

@class WDTNControlTask;
/**
 文件上传,支持分块上传
 */
@interface WDTNUploadManager : NSObject
/// 默认并发数4，可动态修改。
@property (nonatomic, assign) NSInteger maximumConnections;

/**
 如果有 cancelAllTasks 需求的，请使用 init 方法创建一个新对象
 */
+ (instancetype)defaultManager;

/**
 发起请求，上传文件
 */
- (WDTNControlTask *)postWithFormData:(WDTNMultipartFormData *)formData
                                success:(WDTNReqResSuccessBlock)success
                                failure:(WDTNReqResFailureBlock)failure;

@end

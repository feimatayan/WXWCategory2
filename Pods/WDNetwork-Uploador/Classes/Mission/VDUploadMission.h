//
// Created by weidian2015090112 on 2018/8/29.
// Copyright (c) 2018 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VDUploadMissionProtocol.h"
#import "VDFileUploadConstant.h"


@class WDNetworkDataTask;
@class VDUploadResultDO, WDNErrorDO;

@interface VDUploadMission : NSObject <VDUploadMissionProtocol>

@property (nonatomic, copy  ) NSString          *scope;
@property (nonatomic, copy  ) NSString          *uploadId;
@property (nonatomic, copy  ) NSString          *sessionId;

@property (nonatomic, strong) NSData            *fileData;
@property (nonatomic, copy  ) NSString          *filePath;
@property (nonatomic, assign) BOOL              isOriginPath;
@property (nonatomic, copy  ) NSString          *originPath;

@property (nonatomic, assign) VDUploadType      type;
@property (nonatomic, assign) BOOL              prv;
@property (nonatomic, assign) BOOL              unadjust;

@property (nonatomic, copy  ) NSDictionary      *postParam;

@property (nonatomic, assign, readonly) BOOL isCancel;
@property (nonatomic, strong, readonly) NSString *fileType;
@property (nonatomic, strong, readonly) NSString *mimeType;

- (double)timeout;

// 进度
@property (nonatomic, strong) NSProgress *progress;

@property (nonatomic, copy) void(^progressBlock)(NSProgress *progress);
@property (nonatomic, copy) void(^completeBlock)(VDUploadResultDO *result, WDNErrorDO *error);

// 重试次数
@property (nonatomic, assign) NSUInteger retryTimes;

// UT
@property (nonatomic, assign)   NSInteger       utRequestSize;
@property (nonatomic, copy  )   NSString       *utTraceId;
@property (nonatomic, assign)   NSInteger       utResponseSize;
@property (nonatomic, assign)   NSInteger       utHttpStatusCode;
@property (nonatomic, assign)   CFAbsoluteTime  utHttpTime;
@property (nonatomic, assign)   long long       utUploadFileSize;
@property (nonatomic, assign)   BOOL            utUploadRetry;
@property (nonatomic, assign)   NSInteger       utUploadRetryCount;
@property (nonatomic, assign)   NSInteger       utChunkCount;

- (void)sendUT:(VDUploadResultDO *)result error:(WDNErrorDO *)error;

- (NSString *)zipSign:(NSData *)fileData;

@end

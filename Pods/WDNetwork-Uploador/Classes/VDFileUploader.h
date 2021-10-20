//
//  VDFileUploader.h
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/7.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "VDFileUploadConstant.h"


@class VDUploadResultDO, WDNErrorDO;

@interface VDFileUploader : NSObject

+ (void)holdUploader:(VDFileUploader *)uploader;

+ (void)removeUploader:(VDFileUploader *)uploader;

+ (void)cancelAllUploader:(WDNErrorDO *)error;

/**
 自动选择分片上传

 @param data 文件
 @param scope ""
 @param type 文件类型
 @param quality 图片压缩质量
 @param prv 是否私有, YES表示是私有图片
 @param unadjust 是否服务器端调整, YES表示不需要调整
 @param progress 上传进度
 @param complete 回调

 @return ""
 */
+ (id)UploadFile:(id)data
           scope:(NSString *)scope
            type:(VDUploadType)type
         quality:(CGFloat)quality
             prv:(BOOL)prv
        unadjust:(BOOL)unadjust
        progress:(void(^)(NSProgress *progress))progress
        complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete;

/**
 视频查询，没什么用
 */
+ (instancetype)QueryVideo:(NSString *)videoId
                     scope:(NSString *)scope
                  callback:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))callback;

#pragma mark -

// SDK内部使用，不要修改
@property (nonatomic, assign) NSInteger index;

// 公共参数
@property (nonatomic, copy  ) NSString      *uploadId;
@property (nonatomic, copy  ) NSString      *sessionId;
@property (nonatomic, copy  ) NSString      *scope;
@property (nonatomic, assign) VDUploadType  type;
@property (nonatomic, assign) CGFloat       quality;
@property (nonatomic, assign) BOOL          prv;
@property (nonatomic, assign) BOOL          unadjust;

@property (nonatomic) dispatch_queue_t currentQueue;

@property (nonatomic, strong) NSProgress *aProgress;

@property (nonatomic, copy) void(^progress)(NSProgress *);

@property (nonatomic, copy) void(^complete)(VDUploadResultDO *, WDNErrorDO *);

@property (nonatomic, strong) VDUploadResultDO *result;

- (void)cancel;

- (void)cancel:(WDNErrorDO *)error;

@end

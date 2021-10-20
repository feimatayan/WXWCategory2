//
//  WDTNFileDownloader.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/3.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DownloadDirName = @"NEDownload";

@class WDTNControlTask;
@interface WDTNFileDownloader : NSObject

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
@property (nonatomic, strong) dispatch_group_t completionGroup;


/**
 默认的单例类，如果需要可以通过 init 创建一个对象。
 */
+ (instancetype)defaultLoader;

/**
 小文件下载，返回NSData对象，本地磁盘不保存。
 如不指定completionQueue，在主线程回调。
 */
- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSData *data, NSURLRequest *request))success
                 failure:(void (^)(NSError *error, NSURLRequest *request))failure;

/**
 isBigFile == YES,使用 NSURLSessionDownloadTask 下载文件到磁盘，不缓存 data;
 isBigFile == NO, 使用 NSURLSessionDataTask 下载文件，缓存 data.
 
 filePath == nil, 小文件不保存 data 到磁盘，大文件使用临时路径保存文件;
 filePath != nil, 小文件保存 data 到磁盘，大文件直接保存到该路径。

 如不指定completionQueue，在主线程回调。
 */
- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
               isBigFile:(BOOL)isBigFile
                filePath:(NSString *)filePath
                 success:(void (^)(NSData *data, NSString *tmpPath, NSURLRequest *request))success
                 failure:(void (^)(NSError *error, NSURLRequest *request))failure;


/**
 isBigFile == YES,使用 NSURLSessionDownloadTask 下载文件到磁盘，不缓存 data;
 isBigFile == NO, 使用 NSURLSessionDataTask 下载文件，缓存 data.
 
 filePath == nil, 小文件不保存 data 到磁盘，大文件使用临时路径保存文件;
 filePath != nil, 小文件保存 data 到磁盘，大文件直接保存到该路径。
 
 如不指定completionQueue，在主线程回调。

 @param url ""
 @param parameters ""
 @param isBigFile ""
 @param filePath ""
 @param delTmpFile 是否删除临时文件
 @param success ""
 @param failure ""
 @return ""
 */
- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
               isBigFile:(BOOL)isBigFile
                filePath:(NSString *)filePath
              delTmpFile:(BOOL)delTmpFile
                 success:(void (^)(NSData *data, NSString *tmpPath, NSURLRequest *request))success
                 failure:(void (^)(NSError *error, NSURLRequest *request))failure;


@end

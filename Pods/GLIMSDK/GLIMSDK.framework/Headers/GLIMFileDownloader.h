//
//  GLIMFileDownloader.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GLIMFileDownloadBlock)(NSString *cachePath, NSData *fileData);

@interface GLIMFileDownloader : NSObject

/**
 *  @author huangbiao, 17-02-18
 *
 *  根据url下载文件
 *
 *  @param urlString    文件url
 *  @param completion   请求回调，fileData 返回的文件数据
 */
+ (void)downloadFileWithUrl:(NSString *)urlString
                 completion:(void (^)(NSData *fileData))completion;

/**
 *  @author huangbiao, 17-02-18
 *
 *  下载和指定用户的聊天文件
 *
 *  @param urlString    文件url
 *  @param uid          指定用户，用于生成缓存路径
 *  @param completion   请求回调，cachePath 文件缓存路径，fileData 返回的文件数据
 */
+ (void)downloadFileWithUrl:(NSString *)urlString
                     forUID:(NSString *)uid
                 completion:(GLIMFileDownloadBlock)completion;

/**
 *  @author huangbiao, 17-02-18
 *
 *  下载和指定用户的聊天音频文件(实际逻辑与下载文件一致，为音频文件做了些特殊处理)
 *
 *  @param urlString    文件url
 *  @param uid          指定用户，用于生成缓存路径
 *  @param completion   请求回调，cachePath 文件缓存路径，fileData 返回的文件数据
 */
+ (void)downloadAudioFileWithUrl:(NSString *)urlString
                          forUID:(NSString *)uid
                      completion:(GLIMFileDownloadBlock)completion;

@end

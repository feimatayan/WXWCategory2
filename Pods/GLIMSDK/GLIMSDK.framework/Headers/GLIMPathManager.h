//
//  GLIMPathManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/16.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMPathManager : NSObject

#pragma mark - 文件缓存相关
/// app数据持久化目录
+ (NSString *)appStoragePath;
// 数据库缓存地址
+ (NSString *)imDBPath;
// 文件缓存地址
+ (NSString *)imCachePath;

#pragma mark - Bundle相关
/**
 *  @author huangbiao, 16-05-09 17:05:33
 *
 *  获取SDK中的资源文件bundle
 *
 *  @return SDK中的资源文件bundle
 */
+ (NSBundle *)imCurrentBundle;

/**
 *  @author huangbiao, 16-05-09 17:05:27
 *
 *  获取SDK中指定文件名称的路径
 *
 *  @param name 文件名称
 *  @param ext  文件后缀
 *
 *  @return 文件路径
 */
+ (NSURL *)imBundleURLForResource:(NSString *)name withExtension:(NSString *)ext;

@end

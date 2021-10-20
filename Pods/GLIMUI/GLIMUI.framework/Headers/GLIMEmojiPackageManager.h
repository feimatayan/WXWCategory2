//
//  GLIMEmojiPackageManager.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/7.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLIMEmojiPackageData.h"
#import "GLIMUIBlockDefine.h"

@class GLIMEmojiData;

/// 负责表情包的下载、更新
@interface GLIMEmojiPackageManager : NSObject

@property (nonatomic, assign) NSInteger sourceType;

@property (nonatomic, strong) NSMutableArray *packageDataArray;

+ (instancetype)sharedInstance;

/**
 加载本地表情包
 */
- (void)loadLocalPackageDatas;

/**
 加载服务器表情包（在拉取完成服务器配置后调用）
 */
- (void)loadServerPackageDatas;

/**
 刷新表情包数据
 */
- (void)refreshPackageDatas;

/// 下载表情包
- (void)downloadPackageZip:(GLIMEmojiPackageData *)packageData completion:(void (^)())completion;

/// 解压表情包
- (void)unZipPackage:(GLIMEmojiPackageData *)packageData completion:(void (^)())completion;

/// 解析表情包
- (void)parsePackageData:(GLIMEmojiPackageData *)packageData;

- (void)parsePackageData:(GLIMEmojiPackageData *)packageData  completion:(void (^)(id obj))completion;

/**
 DEPRECATED 根据表情名称获取表情包中的表情图片

 @param emojiName   表情名称
 @param packageData 表情包
 @return 表情图片
 */
- (UIImage *)emojiImageWithEmojiName:(NSString *)emojiName
                           inPackage:(GLIMEmojiPackageData *)packageData;

/**
 DEPRECATED 根据表情数据获取表情包中的表情图片

 @param emojiData       表情数据
 @param packageData     表情包
 @return 表情图片
 */
- (UIImage *)emojiImageWithEmojiData:(GLIMEmojiData *)emojiData
                           inPackage:(GLIMEmojiPackageData *)packageData;


/**
 根据表情名称获取表情包中的表情图片

 @param emojiName 表情名称
 @param packageData 表情包
 @param completion 回调函数，成功返回表情图片，失败返回nil
 */
- (void)emojiImageWithEmojiName:(NSString *)emojiName
                      inPackage:(GLIMEmojiPackageData *)packageData
                     completion:(GLIMAnimatedImageBlock)completion;

/**
 根据表情数据获取表情包中的表情图片

 @param emojiData 表情数据
 @param packageData 表情包
 @param completion 回调函数，成功返回表情图片，失败返回nil
 */
- (void)emojiImageWithEmojiData:(GLIMEmojiData *)emojiData
                      inPackage:(GLIMEmojiPackageData *)packageData
                     completion:(GLIMAnimatedImageBlock)completion;

/**
 根据表情名称获取表情包中的表情数据

 @param emojiName 表情名称
 @param packageData 表情包
 @return 表情数据
 */
- (GLIMEmojiData *)emojiDataWithName:(NSString *)emojiName
                           inPackage:(GLIMEmojiPackageData *)packageData;


@end

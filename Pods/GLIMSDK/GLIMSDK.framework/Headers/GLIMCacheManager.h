//
//  GLIMCacheManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/18.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 缓存的资源类型
typedef NS_ENUM(NSInteger, GLIMCacheResourceType) {
    GLIMCacheResourcePublic,        // 所有账号公共资源，如各种icon、emoji表情
    GLIMCacheResourceAccount,       // 当前账号的公共资源，如联系人头像
    GLIMCacheResourceTemp,          // 当前账号的临时资源，
//    GLIMCacheResourceChat,          // 当前账号所有聊天资源，如聊天图片、聊天语音
    GLIMCacheResourceChatImage,     // 当前账号的聊天图片
    GLIMCacheResourceChatAudio,     // 当前账号聊天语音
};

@protocol GLIMCacheManagerDelegate <NSObject>

@optional
/// 根据数据返回gif图片
/// @param imageData 图片数据
- (UIImage *)gifImageWithData:(NSData *)imageData;

@end

@interface GLIMCacheManager : NSObject

/// 当前登录用户的imUID
@property (nonatomic, strong) NSString *userID;
/// 当前登录用户的缓存根目录
@property (nonatomic, strong, readonly) NSString *accountRootPath;

@property (nonatomic, weak) id<GLIMCacheManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)reset;

/// 获取指定聊天对象的图片缓存路径（对应GLIMCacheResourceChatImage）
- (NSString *)imageCachePathWithChatID:(NSString *)chatID;
/// 获取指定聊天对象的语音缓存路径（对应GLIMCacheResourceChatAudio）
- (NSString *)audioCachePathWithChatID:(NSString *)chatID;
/// 临时缓存路径（对应GLIMCacheResourceTemp）
- (NSString *)temporaryCachePath;

#pragma mark - Cache in memory and disk
/**
 将文件数据通过文件描述缓存到指定目录下

 @param fileData        文件数据
 @param key             文件描述（文件名由key通过md5生成）
 @param resourceType    缓存类型，不同类型缓存到不同目录下
 @param chatID          当前聊天对象，根据resourceType设置，如果非语音与图片可不传
 */
- (void)storeData:(NSData *)fileData
           forKey:(NSString *)key
     resourceType:(GLIMCacheResourceType)resourceType
           chatID:(NSString *)chatID;

/**
 根据文件描述获取指定目录下缓存的文件数据

 @param key             文件描述（文件名由key通过md5生成）
 @param resourceType    缓存类型，不同类型缓存到不同目录下
 @param chatID          当前聊天对象，根据resourceType设置，如果非语音与图片可不传
 @return 文件数据
 */
- (NSData *)fileDataForKey:(NSString *)key
              resourceType:(GLIMCacheResourceType)resourceType
                    chatID:(NSString *)chatID;

/**
 根据文件描述获取指定目录下缓存的文件路径
 本方法只生成路径，不确定文件是否存在

 @param key             文件描述（文件名由key通过md5生成）
 @param resourceType    缓存类型，不同类型缓存到不同目录下
 @param chatID          当前聊天对象，根据resourceType设置，如果非语音与图片可不传
 @return 缓存文件路径
 */
- (NSString *)filePathForKey:(NSString *)key
                resourceType:(GLIMCacheResourceType)resourceType
                      chatID:(NSString *)chatID;

/**
 根据文件描述判断文件是否存在指定目录下

 @param key 文件描述（文件名由key通过md5生成）
 @param resourceType 缓存类型，不同类型缓存到不同目录下
 @param chatID 当前聊天对象，根据resourceType设置，如果非语音与图片可不传
 @return YES : 文件存在，NO : 文件不存在
 */
- (BOOL)isDataExistedForKey:(NSString *)key
               resourceType:(GLIMCacheResourceType)resourceType
                     chatID:(NSString *)chatID;
/**
 根据文件描述删除指定目录下的文件

 @param key             文件描述（文件名由key通过md5生成）
 @param resourceType    缓存类型，不同类型缓存到不同目录下
 @param chatID          当前聊天对象，根据resourceType设置，如果非语音与图片可不传
 */
- (void)removeDataForKey:(NSString *)key
            resourceType:(GLIMCacheResourceType)resourceType
                  chatID:(NSString *)chatID;


/**
 清空指定用户的缓存数据

 @param chatID      用户ID
 */
- (void)clearDatasForChatID:(NSString *)chatID;

#pragma mark - Only cache in memory

/**
 将数据缓存到内存中

 @param cache   待缓存数据
 @param key     缓存数据描述
 */
- (void)storeCacheInMemory:(id)cache forKey:(NSString *)key;

/**
 根据描述信息获取缓存数据

 @param key 缓存数据描述
 @return 缓存的数据
 */
- (id)cacheInMemoryWithKey:(NSString *)key;

- (void)clearAccountDatas;

@end

@interface GLIMCacheManager (ImageCache)

/**
 保存图片

 @param image 图片对象
 @param key 图片对应的key
 @param resourceType 保存的资源类型
 @param chatID 聊天对象
 */
- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
      resourceType:(GLIMCacheResourceType)resourceType
            chatID:(NSString *)chatID;

- (UIImage *)imageWithKey:(NSString *)key
             resourceType:(GLIMCacheResourceType)resourceType
                   chatID:(NSString *)chatID;

- (id)cacheImageWithKey:(NSString *)key
           resourceType:(GLIMCacheResourceType)resourceType
                 chatID:(NSString *)chatID;

- (BOOL)imageExistInCacheWithKey:(NSString *)key
                    resourceType:(GLIMCacheResourceType)resourceType
                          chatID:(NSString *)chatID;

/**
 替换指定key对应的缓存数据

 @param image 待缓存的图片
 @param key 缓存数据的key
 @param resourceType 资源缓存类型
 @param chatID 聊天对象
 */
- (void)replaceCache:(UIImage *)image
              forKey:(NSString *)key
        resourceType:(GLIMCacheResourceType)resourceType
              chatID:(NSString *)chatID;

@end

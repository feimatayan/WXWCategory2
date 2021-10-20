//
//  GLIMDataCache.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/4/21.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 聊天数据缓存
 */
@interface GLIMDataCache : NSObject

/// 最大支持cache数
@property (nonatomic, assign) NSInteger maxCacheSize;

- (void)setCache:(id)cache forKey:(NSString *)key;
- (id)cacheForKey:(NSString *)key;

- (void)clearCache;

@end

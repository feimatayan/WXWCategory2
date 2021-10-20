//
//  WDEmojiManager.h
//  WDEmoji
//
//  Created by 陈岳燊 on 2020/11/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WDEmojiInfoDO;

NS_ASSUME_NONNULL_BEGIN

@interface WDEmojiManager : NSObject

+ (instancetype)instance;

/**
 * 获取emoji image
 * @param path emoji图片文件名称
 * @param bundlePath bundle路径 不传的话默认主bundle
 * @return emoji UIImage实例
 */
+ (UIImage *)emojiImageWithPath:(NSString *)path bundlePath:(NSString *)bundlePath;

/**
 * 字典方式返回emoji信息
 * @return 字典格式的emoji信息
 */
- (NSDictionary *)emojiInfoDic;

/**
 * 格式化数据方式返回emoji信息
 * @return 格式化数据格式的emoji信息
 */
- (WDEmojiInfoDO *)emojiInfo;

/**
 * 返回emoji item的
 * @return emojiKeyPath 字典
 */
- (NSDictionary *)emojiKeyPathDic;

@end

NS_ASSUME_NONNULL_END

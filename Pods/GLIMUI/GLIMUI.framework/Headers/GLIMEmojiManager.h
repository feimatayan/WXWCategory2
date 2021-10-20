//
//  GLIMEmojiManager.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/4.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLIMEmojiData.h"
#import "GLIMUIBlockDefine.h"
#import "GLIMEmojiPackageData.h"


@interface GLIMEmojiManager : NSObject

@property (nonatomic, strong) NSMutableArray *emojiPackageArray;
@property (nonatomic, strong) NSMutableArray *smallWeiXinEmojiDataArray;

//新的小表情
@property (nonatomic, strong) GLIMEmojiPackageData *newEmojiPackageData;

+ (instancetype)sharedInstance;

/**
 刷新表情包数据，每次打开输入框页面时使用
 */
- (void)refreshPackageDatas;

/**
 根据表情名称判断是不是存在表情

 @param emojiName 表情名称
 @return YES：找到对象表情
 */
- (BOOL)isEmojiWithName:(NSString *)emojiName;

/**
 根据表情名获取表情名称（小表情）

 @param emojiName 表情名称
 @return 表情对象
 */
- (GLIMEmojiData *)emojiDataWithName:(NSString *)emojiName;


/**
 根据表情名和表情包名获取表情名称（大表情）
 图片是子线程获取的，使用时需要手动切回主线程

 @param emojiName   表情名称
 @param packageName 表情包名
 @param completion  回调函数
 */
- (void)getBigEmojiImage:(NSString *)emojiName
             packageName:(NSString *)packageName
              completion:(GLIMAnimatedImageBlock)completion;


/**
 根据表情名和表情包名获取表情名称（大表情）
 图片是子线程获取的，使用时需要手动切回主线程
 
 @param emojiName   表情名称
 @param packageName 表情包名
 */
- (GLIMEmojiData *)emojiDataWithName:(NSString *)emojiName
                         packageName:(NSString *)packageName;


- (GLIMEmojiPackageData *)emojiCustomExpressionPackageData;


- (UIImage *)newEmojiImageWithPath:(NSString *)path bundlePath:(NSString *)bundlePath ;

/// 初始表情包数据，通用的表情包数据，不包含Hibo和自定义表情
/// 注：由于内部数据变化都在主线程，最好确保此处也在主线程上
- (NSMutableArray *)originalEmojiPackageArray;

@end

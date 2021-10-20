//
//  GLIMMessageCellCache.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/22.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>


@protocol GLIMMessageCellCacheDelegate <NSObject>
@optional
//messageCellCache是否支持缓存自己Name的高度
- (BOOL)messageCellCacheIsSupportmySelfShowName;
@end

/*
 cell高度缓存 
 */
@interface GLIMMessageCellCache : NSObject

+ (GLIMMessageCellCache *)shareCache;

//cache缓存的标记 默认无 不同页面用cellcache时需赋值 页面退出时需清空
@property (nonatomic,strong)NSString * cacheSign;
@property (nonatomic,weak) id<GLIMMessageCellCacheDelegate> delegate;

//cellSize的缓存 缓存中没有，则实时计算并缓存 会同时缓存cellSize和cellContentSize

/**
 获取单聊消息Cell显示尺寸，
 如果缓存中不存在对应尺寸则会计算尺寸

 @param message 消息数据
 @return 显示尺寸
 */
- (CGSize)sizeForCellWithMessage:(GLIMMessage *)message;

/**
 获取消息Cell显示尺寸，
 如果缓存中不存在对应尺寸则会计算尺寸

 @param message 消息数据
 @param chatType 聊天类型
 @return 显示尺寸
 */
- (CGSize)sizeForCellWithMessage:(GLIMMessage *)message
                        chatType:(GLIMChatType)chatType;

//获取cellContent的缓存 缓存内容包括 congtentSize labelSize cell子类可以随便设置
- (NSDictionary *)cellContentWithMessage:(GLIMMessage *)message;
//
- (void)clearCellCacheWithMessage:(GLIMMessage *)message;

//根据消息和cacheSign清除缓存
- (void)clearCellCacheWithMessage:(GLIMMessage *)message withCacheSign:(NSString *)cacheSign;

//清空
- (void)reset;
@end

//
//  GLIMMessageBottomActionConfig.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/3.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMMessageBottomActionItemData.h"

@interface GLIMMessageBottomActionConfig : NSObject

/// 扩展输入Item数组
@property (nonatomic, strong) NSMutableArray<GLIMMessageBottomActionItemData *> *actionItemArray;

/// 群聊的Item数组
@property (nonatomic, strong) NSMutableArray<GLIMMessageBottomActionItemData *> *groupActionItemArray;

+ (instancetype)sharedInstance;

/**
 配置默认的输入入口，仅显示相册和拍照
 */
- (void)configDefaultActionItems;

#pragma mark - 配置ActionItems
/// 注册actionItem到config里（如果有对应的actionItem直接替换）
- (void)registActionItemData:(GLIMMessageBottomActionItemData *)itemData;
/// 从config中移除actionItem
- (void)removeActionItemData:(GLIMMessageBottomActionItemData *)itemData;
/// 移除所有actionItem
- (void)removeAllActionItemDatas;

/**
 注册actionItem到Config里

 @param itemData actionItem数据
 @param forceReplace 如果config不包含actionItem，则注册到config里
 如果config已经有actionItem，且forceReplace为YES：则强制替换，否则不做任何操作
 */
- (void)registActionItemData:(GLIMMessageBottomActionItemData *)itemData
                forceReplace:(BOOL)forceReplace;


/**
 替换actionItem的部分属性
 用于本地配置的actionItem，目前用来替换hasBadge

 @param itemData actionItem数据
 */
- (void)replacePropertyWithActionItemData:(GLIMMessageBottomActionItemData *)itemData;

#pragma mark - 获取ActionItems

/**
 为指定联系人配置显示的actionItems

 @param chat 指定联系人
 @return actionItem列表
 */
- (NSArray *)actionItemArrayWithChat:(GLIMChat *)chat;

/// 缓存actionItems到本地
- (void)saveActionItemDatas;


@end

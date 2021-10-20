//
//  GLIMOfflineMessagePoolManager.h
//  GLIMSDK
//
//  Created by huangbiao on 2020/3/6.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMChat.h"

NS_ASSUME_NONNULL_BEGIN

#define GLIMNOTIFICATION_OFFLINEMESSAGEPOOL_CHAT_CHANGE    @"GLIMNOTIFICATION_OFFLINEMESSAGEPOOL_CHAT_CHANGE"

/// 离线消息池管理
@interface GLIMOfflineMessagePoolManager : NSObject

/// 离线消息池聚合联系人
@property (nonatomic, strong) GLIMChat *combineChat;
/// 离线消息池联系人数
@property (nonatomic, assign) NSInteger contactCount;

+ (instancetype)sharedInstance;

#pragma mark - 聚合联系人

/// 同步联系人数目
/// @param syncCount 待同步的未读数
- (void)syncContactCount:(NSInteger)syncCount;

/// 是否需要隐藏聚合联系人
- (BOOL)hiddenCombineChat;

/// 清空缓存
- (void)clearCache;

#pragma mark -

/// 获取所有子账号列表
/// @param respoonse 回调函数
- (void)querySubAccounListFromServiceResponse:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;

- (void)queryShopListFromServiceWithPageNo:(NSString *)pageNo
                                  pageSize:(NSString *)pageSize
                                   shopUid:(NSString *)shopUid
                              isMasterShop:(NSString *)isMasterShop
                                  response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;

- (void)deleteOfflineContactWithList:(NSArray *)list
                            response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;

- (void)receptionCustomeWithList:(NSArray *)list
                        response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;

- (void)getOfflineMsgContactListWithMsgStartTime:(NSString *)msgStartTime
                                          subUid:(NSString *)subUid
                                            time:(NSString *)time
                                           limit:(NSString *)limit
                                          shopid:(NSString *)shopid
                                     from_source:(NSString *)from_source
                                        response:(void(^ _Nonnull)(NSDictionary* _Nullable resultDict, NSError* _Nullable error))respoonse;

@end

NS_ASSUME_NONNULL_END

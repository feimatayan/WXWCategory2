//
//  GLIMFilterContactsManager.h
//  GLIMSDK
//
//  Created by jiakun on 2020/12/21.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLIMChat.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLIMContactFromSourceCondition : NSObject

/// 来源
@property (nonatomic, assign) GLIMChatFromSourceType fromSource;
/// 标题
@property (nonatomic, copy) NSString *title;

@end

@interface GLIMFilterContactsManager : NSObject

@property (nonatomic, strong) NSMutableArray *list;



/// 记录当前的uid，
@property (nonatomic, copy) NSString *loginUID;

+ (instancetype)sharedInstance;


/// 获取标题
- (NSString *)sourceNameWithType:(NSInteger)type;

/// 筛选条件
- (NSArray *)filteredList;

/// 追加筛选条件
/// @param filterList 筛选列表
- (void)appendFilterList:(NSArray *)filterList;

/// 重置筛选条件
- (void)resetAllFilterList;

/// 包含筛选条件
- (BOOL)containsFilterCondition;

/// 检查是否满足条件
/// @param fromSource 联系人来源
- (BOOL)isMeetingCondition:(GLIMChatFromSourceType)fromSource;

#pragma mark - DEPRECATED

//@property (nonatomic, strong) NSMutableArray *selectList;
//
//- (void)configData;
//
//- (void)setSelect:(BOOL)isSelect v:(NSInteger )v;
//
//- (void)resetAll;
//
//- (NSString *)titleWithFromType:(NSInteger)fromType;

@end

NS_ASSUME_NONNULL_END

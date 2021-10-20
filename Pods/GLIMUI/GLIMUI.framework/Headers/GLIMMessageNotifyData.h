//
//  GLIMMessageNotifyData.h
//  GLIMUI
//
//  Created by huangbiao on 2020/12/28.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 通知数据
@interface GLIMMessageNotifyData : NSObject

/// 数据实体，需要处理的数据
@property (nonatomic, strong) id entity;
/// 标识
@property (nonatomic, copy) NSString *identifier;
/// 显示标题
@property (nonatomic, copy) NSString *title;
/// 显示内容
@property (nonatomic, copy) NSString *body;
/// 显示图片
@property (nonatomic, copy) NSString *imageUrl;
/// 标识是否强弱通知, 0-强通知 1-弱通知 2-超强通知
@property (nonatomic, assign) NSInteger strongWeakNotify;
/// 通知类型，0-单聊通知，1-群聊通知
@property (nonatomic, assign) NSInteger notifyType;

/// 生成通知信息
- (NSDictionary *)notifyInfos;

@end

NS_ASSUME_NONNULL_END

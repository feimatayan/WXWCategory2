//
//  WDUTLogModel.h
//  WDUT
//
//  Created by yuping on 15/12/25.
//  Copyright © 2015年 yuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDUTEventDefine.h"
#import "WDUTConfig.h"

@interface WDUTLogModel : NSObject

@property(nonatomic, copy) NSString *localId;

@property(nonatomic, copy) NSString *eventID;

@property(nonatomic, assign) int priority;

/// 记录的扩展信息
@property(nonatomic, strong) NSDictionary *content;

/// ut自身事件检测
+ (BOOL)isUTEvent:(NSString *)eventId content:(NSDictionary *)content;

/// 获取事件对应所有信息
- (NSDictionary *)getEventDictionary;

- (NSTimeInterval)getLogTimeInterval;

@end

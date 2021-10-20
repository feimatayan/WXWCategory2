//
//  GLIMExtensionEntity.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/12/6.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 消息相关扩展实例基类
@interface GLIMExtensionEntity : NSObject

/// 业务字段信息，用于生成messageDetail
- (NSMutableDictionary *)entityInfos;

/**
 生成业务消息detail字段
 
 @return detail json字符串
 */
- (NSString *)messageDetail;

/**
 根据detail字段解析业务属性
 
 @param detail 消息detail字段
 */
- (void)parsePropertiesFromDetail:(NSString *)detail;


/**
 根据字典解析业务属性

 @param dict 业务字典
 */
- (void)parsePropertiesFromDict:(NSDictionary *)dict;

@end

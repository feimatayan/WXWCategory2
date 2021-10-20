//
//  GLIMBaseObject.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>


@interface GLIMBaseObject : NSObject

/**
 *    本类提供的基于runtime的自动功能, description及NSCoding等，会默认针对所有属性
 *    如果默写属性不希望被包含, 可以在此字典中配置属性名, key为属性名, value为任意字段
 */
@property (nonatomic, strong) NSDictionary<NSString*, id>* runtimeFeatureExcludes;

#pragma mark - db CRUD, auto generated features

+ (instancetype)queryByID:(NSString*)ID;
+ (BOOL)removeByID:(NSString*)ID;
- (BOOL)insert;
- (BOOL)update;

#pragma mark - db features supports

/**
 组装DB操作字符串
 子类需实现

 @return 符合FMDB语法的sql语句
 */
+ (NSString*)insertingSql;
+ (NSString*)queryingSql;
+ (NSString*)updatingSql;
+ (NSString*)removingSql;

/**
 返回当前所有属性值字典，用于自动生成数据库CRUD操作语句，
 ! 注意属性为nil时的处理
 子类需实现

 @return 属性值
 */
- (NSDictionary*)propertiesDict;

/**
 实体ID
 子类需实现
 
 @return 返回实体主键的值
 */
- (NSString*)ID;

#pragma mark - parser

/**
 从数据字典解析实体信息字段
 子类需实现
 
 @param dict 数据字典
 */
- (void)parseFieldsFromDict:(NSDictionary*)dict;

/**
 从数据库结果集解析实体信息字段
 子类需实现
 
 @param resultSet 查询结果
 */
- (void)parseFieldsFromResultSet:(FMResultSet*)resultSet;

/**
 从PB对象解析实体信息字段
 子类需实现
 
 @param pbObject pb对象
 */
- (void)parseFieldsFromPBObject:(id)pbObject;


- (void)parseFieldsFromHttpDict:(NSDictionary*)dict;

//默认等于0
- (NSInteger)glimCompare:(id )pbObject;

- (BOOL)isTop;


@end

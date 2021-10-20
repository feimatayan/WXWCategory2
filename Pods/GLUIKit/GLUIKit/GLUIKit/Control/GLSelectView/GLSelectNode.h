//
//  GLSelect.h
//  WDPlugin_CRM
//
//  Created by xiaofengzheng on 12/26/15.
//  Copyright © 2015 baoyuanyong. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface GLSelectNode : NSObject

/// 父ID
@property (nonatomic, copy) NSString    *parentID;
/// ID
@property (nonatomic, copy) NSString    *currentID;
/// title
@property (nonatomic, copy) NSString    *title;
/// son array
@property (nonatomic, strong) NSArray <GLSelectNode *>   *subArray;
/// 只用在 查找返回 index 使用
@property (nonatomic, assign) NSInteger index;


/**
 *  查找 是个几层 的树
 *
 *  @param rootNode 根节点
 *
 *  @return 层级
 */

+ (NSInteger)checkLayer:(GLSelectNode *)rootNode;


/**
 *  解析城市 树
 *
 *  @param array 数据源
 *
 *  @return 根节点
 */
+ (GLSelectNode *)parseCityTree:(NSArray *)array;


/**
 *  查找 相同节点 不递归查找
 *
 *  @param findeNode 要查找的节点
 *  @param array 数据源
 *  @param isRelation 是否是关系型的
 *
 *  @return 查找的对象
 */
+ (GLSelectNode *)findeSameNode:(GLSelectNode *)findeNode inArray:(NSArray *)array isRelation:(BOOL)isRelation;




@end

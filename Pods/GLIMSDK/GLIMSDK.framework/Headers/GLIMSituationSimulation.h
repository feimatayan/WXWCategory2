//
//  GLIMSituationSimulation.h
//  GLIMSDK
//
//  Created by huangbiao on 2018/4/18.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 场景模拟，仅限开发环境用
 */
@interface GLIMSituationSimulation : NSObject

+ (instancetype)sharedInstance;

/**
 模拟数据库损坏场景
 */
- (void)simulateDatabaseDamanged;

@end

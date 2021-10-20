//
// Created by shazhou on 2018/7/10.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 管理session，与GLAnalysis类似
 * */

@interface WDUTSessionManager : NSObject

+ (WDUTSessionManager *)instance;

+ (NSString *)getSessionId;

@end
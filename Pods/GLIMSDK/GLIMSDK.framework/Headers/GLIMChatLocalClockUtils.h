//
//  GLMChatLocalClockUtils.h
//  GLIMUI
//
//  Created by jiakun on 2018/8/29.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMChatLocalClockUtils : NSObject
//服务器时时间戳 校队本地时间
@property (nonatomic, assign) long long serverTimeInterval;

//本地时间和服务器时间差值
@property (nonatomic, assign) long long loaclWithServerTimeDifferenceInterval;

+ (instancetype)sharedManager;
- (void)startChatLocalClock;
- (void)stopChatLocalClock;
@end

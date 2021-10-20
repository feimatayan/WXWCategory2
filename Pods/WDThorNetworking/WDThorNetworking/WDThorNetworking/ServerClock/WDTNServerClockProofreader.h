//
//  WDTNServerClockProofreader.h
//  WDTNServerClockProject
//
//  Created by wangcheng on 2016/11/17.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDTNServerClockProofreader : NSObject

+ (instancetype)sharedInstance;

/**
 * thor时间校验
 */
- (long long)currentServerTime;

/**
 * thor服务器时间更新
 **/
- (void)updateServerTime:(long long)serverTime;

/**
 返回 proxy 服务器时间，单位：毫秒;
 
 @param isServerTime NO:接口获取时间失败，返回本地时间, YES: 服务器时间
 */
- (long long)currentTime:(BOOL *)isServerTime;

@end

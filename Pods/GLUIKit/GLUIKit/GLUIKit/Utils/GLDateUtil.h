//
//  GLDateUtil.h
//  BanJia
//
//  Created by xiaofengzheng on 14-9-18.
//  Copyright (c) 2014年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#define kGroupName_Today        @"今天"
#define kGroupName_Yesterday    @"昨天"
//#define kGroupName_OneDayAgo    @"两天天前"
#define kGroupName_TwoDayAgo    @"两天前"
#define kGroupName_ThreeDayAgo  @"三天前"
#define kGroupName_FourDayAgo   @"四天前"
#define kGroupName_FiveDayAgo   @"五天前"
#define kGroupName_SixDayAgo    @"六天前"
//#define kGroupName_SevenDayAgo  @"七天前更新"


#import <Foundation/Foundation.h>

@interface GLDateUtil : NSObject

+ (NSString *)localDateByDay:(NSString *)dateStr hasTime:(BOOL)hasTime;
/// 显示开始抢购时间
+(NSString*)getDateStringValue:(NSTimeInterval)startTime curDate:(NSTimeInterval)curTime;
/// 显示时间：08/15日 10:00
+(NSString*)getTimeString:(NSTimeInterval)ntime;
/// 显示剩余时间：10时00分00秒
+(NSArray *)getRemainTimeString:(NSTimeInterval)remaintime perString:(NSString*)strPer;
/// 显示今天更新
+ (NSString *)getGroupName:(NSTimeInterval)timeInterval;


@end

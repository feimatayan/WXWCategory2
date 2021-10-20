//
//  WDUTLogModel.m
//  WDUT
//
//  Created by yuping on 15/12/25.
//  Copyright © 2015年 yuping. All rights reserved.
//

#import "WDUTLogModel.h"
#import "NSMutableDictionary+WDUT.h"
#import "WDUTConfig.h"
#import "WDUTMacro.h"

@implementation WDUTLogModel

+ (BOOL)isUTEvent:(NSString *)eventId content:(NSDictionary *)content {
    if (eventId.length <= 0) {
        return NO;
    }
    //ut错误
    if ([eventId isEqualToString:WDUT_EVENT_TYPE_UT_ERROR]) {
        return YES;
    }

    //缓存队列满
    if ([eventId isEqualToString:WDUT_EVENT_TYPE_UT_CACHE_FULL]) {
        return YES;
    }

    //ut网络请求日志
    if ([eventId isEqualToString:@"3103"] && [content[WDUT_EVENT_FIELD_PAGE] isEqualToString:WDUT_PAGE_FIELD_UT]) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)getEventDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wdutSetObject:self.eventID forKey:WDUT_EVENT_FIELD_EVENTID];

    if (self.content) {
        [dict addEntriesFromDictionary:self.content];
    }
    //补一下appkey
    [dict wdutSetObject:[WDUTConfig instance].appKey forKey:WDUT_EVENT_FIELD_APP_KEY];

    return dict;
}

- (NSTimeInterval)getLogTimeInterval {
    if ([self.content objectForKey:WDUT_EVENT_FIELD_LOCAL_TIMESTAMP]) {
        return [[self.content objectForKey:WDUT_EVENT_FIELD_LOCAL_TIMESTAMP] doubleValue];
    }
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

@end

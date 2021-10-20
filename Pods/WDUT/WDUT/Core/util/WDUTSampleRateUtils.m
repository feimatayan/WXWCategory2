//
//  WDUTSampleRateUtils.m
//  WDUT
//
//  Created by WeiDian on 16/3/30.
//  Copyright © 2016 WeiDian. All rights reserved.
//


#import "WDUTSampleRateUtils.h"
#import "WDUTManager.h"

@interface WDUTSampleRateUtils ()

@end

@implementation WDUTSampleRateUtils

+ (BOOL)isNeedCollection:(NSString *)eventID isSuccess:(BOOL)isSuccess {
    NSInteger rate = [self findSampleRateForEventID:eventID isSuccess:isSuccess];
    NSInteger randomInt = [self getRandomNumber:0 to:99];
    if (rate == -1 || randomInt < rate) {
        return YES;
    }

    return NO;
}

+ (BOOL)isSelfNeedCollection {
    NSInteger randomInt = [self getRandomNumber:0 to:99];
    if ([WDUTConfig instance].selfSampleRate >= randomInt) {
        return YES;
    }

    return NO;
}

#pragma mark - private methods

+ (NSInteger)findSampleRateForEventID:(NSString *)eventID isSuccess:(BOOL)isSuccess {
    NSInteger rate = -1;

    NSDictionary *sampleMap = [WDUTConfig instance].sampleRateMap;
    if ([sampleMap objectForKey:eventID] != nil) {
        NSDictionary *dict = [sampleMap objectForKey:eventID];
        if (isSuccess) {
            rate = [[dict objectForKey:@"rateOfSuccess"] integerValue];
        } else {
            rate = [[dict objectForKey:@"rateOfFailed"] integerValue];
        }
    }

    return rate;
}

+ (NSInteger)getRandomNumber:(NSInteger)fromInt to:(NSInteger)toInt {
    return (NSInteger) (fromInt + (arc4random() % (toInt - fromInt + 1)));
}

@end

//
//  WDUTSampleRateUtils.h
//  WDUT
//
//  Created by WeiDian on 16/3/30.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WDUTSampleRateUtils : NSObject

+ (BOOL)isNeedCollection:(NSString *)eventID isSuccess:(BOOL)isSuccess;

+ (BOOL)isSelfNeedCollection;

@end
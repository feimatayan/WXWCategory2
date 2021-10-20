//
//  WDIEStatisticsManager.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/6/25.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WDIEStatisticsDelegate;

@interface WDIEStatisticsManager : NSObject

@property (nonatomic, weak) id<WDIEStatisticsDelegate> delegate;

+ (instancetype)sharedManager;

- (void)logWithID:(NSString *)ID params:(NSDictionary *)params;

@end

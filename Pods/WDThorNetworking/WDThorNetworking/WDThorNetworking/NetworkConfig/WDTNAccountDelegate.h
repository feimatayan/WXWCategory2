//
//  WDTNAccountDelegate.h
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/11/6.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WDTNPerformTask;

@protocol WDTNAccountDelegate <NSObject>

@optional

- (void)thorRefreshToken:(WDTNPerformTask *)task
                callback:(void(^)(WDTNPerformTask *task, BOOL refreshSuccess, BOOL needRelogin))callback;

- (void)thorReLogin:(WDTNPerformTask *)task
           callback:(void(^)(WDTNPerformTask *task, BOOL loginSuccess))callback;

@end

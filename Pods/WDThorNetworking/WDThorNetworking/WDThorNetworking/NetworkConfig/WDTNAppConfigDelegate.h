//
//  WDTNAppConfigDelegate.h
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/3/21.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WDTNAppConfigDelegate <NSObject>

@optional

- (void)thorResponse:(NSDictionary *)headDict;

@end

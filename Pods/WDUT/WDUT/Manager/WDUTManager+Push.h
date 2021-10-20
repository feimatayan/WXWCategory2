//
//  WDUTManager+Push.h
//  WDUTManager
//
//  Created by WeiDian on 15/12/24.
//  Copyright © 2018 WeiDian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDUTManager.h"

@interface WDUTManager (Push)

- (void)pushRegister:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3 args:(NSDictionary *)args;

- (void)pushArrive:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3 args:(NSDictionary *)args;

- (void)pushDisplay:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3 args:(NSDictionary *)args;

- (void)pushOpen:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3 args:(NSDictionary *)args;

@end

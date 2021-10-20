//
// Created by shazhou on 2018/7/15.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDUTManager.h"

@interface WDUTManager (LifeCycle)

- (void)registerObserver;

- (void)pageAppear:(UIViewController *)page;

- (void)pageDisappear:(UIViewController *)page pageName:(NSString *)pageName;

- (void)updateController:(id)controller
                pageName:(NSString *)pageName
                    args:(NSDictionary *)args;

- (NSDictionary *)getControllerArgs:(id)controller;

- (NSString *)getLastControllerName:(id)controller;

- (NSString *)getPageNameWithControllerClass:(Class)controllerClass __attribute__((deprecated("Use getPageNameWithController instead.")));

- (NSString *)getPageNameWithController:(id)controller;

- (void)commitPageEventManually:(id)controller;

@end

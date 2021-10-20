//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (WDBlocksKit)

- (void)wd_whenTapped:(void (^)(void))block;

- (void)wd_touchEndedBlock:(void(^)(UIView *selfView))block;

@end
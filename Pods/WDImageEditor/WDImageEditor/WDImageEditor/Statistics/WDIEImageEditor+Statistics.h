//
//  WDIEImageEditor+Interface.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/6/25.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <WDImageEditor/WDImageEditor.h>
#import "WDIEStatisticsDelegate.h"

@interface WDIEImageEditor (Statistics)

+ (void)setStatisticsDelegate:(id<WDIEStatisticsDelegate>)delegate;

@end

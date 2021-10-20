//
//  WDTNDefines.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNDefines.h"

NSString * const WDTNRequestConfigForHTTP = @"WDTNRequestConfigForHTTP";

NSString * const WDTNRequestConfigForProxy = @"WDTNRequestConfigForProxy";

NSString * const WDTNRequestConfigForCommon = @"WDTNRequestConfigForCommon";

NSString * const WDTNRequestConfigForUpgrade = @"WDTNRequestConfigForUpgrade";

NSString * const WDTNRequestConfigForThor = @"WDTNRequestConfigForThor";            //Thor线上环境

NSString * const WDTNRequestConfigForThorPre = @"WDTNRequestConfigForThorPre";      //Thor预发环境

NSString * const WDTNRequestConfigForThorTest = @"WDTNRequestConfigForThorTest";    //Thor日常测试环境


dispatch_queue_t wdtn_create_default_queue(const char * label, long identifier) {
    dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(identifier, 0);
    dispatch_set_target_queue(queue, globalQueue);
    return queue;
}

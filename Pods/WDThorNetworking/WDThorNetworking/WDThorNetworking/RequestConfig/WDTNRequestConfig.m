//
//  WDTNRequestConfig.m
//  WDBJNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 wangchengweidian. All rights reserved.
//

#import "WDTNRequestConfig.h"
#import "WDTNNetwrokConfig.h"

@implementation WDTNRequestConfig

- (instancetype)init {
    if (self = [super init]) {
        _varHeaderDelegate = [WDTNNetwrokConfig sharedInstance].varHeaderDelegate;
        _staticHeaderDelegate = [WDTNNetwrokConfig sharedInstance].staticHeaderDelegate;
        _appConfigDelegate = [WDTNNetwrokConfig sharedInstance].appConfigDelegate;
    }
    
    return self;
}

- (instancetype)initWithConfigType:(NSString *)configType
                    reqEncryStatus:(NSInteger)status
                        reqZipType:(NSInteger)type
                         passKeyId:(NSString *)keyid
                         signKeyId:(NSString *)signid
                     queuePriority:(NSInteger)priority {
    if (self = [self init]) {
        _configType = configType;
        _reqEncryStatus = status;
        _reqZipType = type;
        _passKeyId = keyid;
        _signKeyId = signid;
        _queuePriority = priority;
    }
    
    return self;
}

-( id<WDTNVarHeaderOnSceneDelegate> ) varHeaderDelegate {
    if ( nil == _varHeaderDelegate ) {
        _varHeaderDelegate = [WDTNNetwrokConfig sharedInstance].varHeaderDelegate;
    }
    return _varHeaderDelegate;
}

-( id<WDTNStaticHeaderOnSceneDelegate> ) staticHeaderDelegate {
    if ( nil == _staticHeaderDelegate ) {
        _staticHeaderDelegate = [WDTNNetwrokConfig sharedInstance].staticHeaderDelegate;
    }
    return _staticHeaderDelegate;
}

-( id<WDTNAppConfigDelegate> ) appConfigDelegate {
    if ( nil == _appConfigDelegate ) {
        _appConfigDelegate = [WDTNNetwrokConfig sharedInstance].appConfigDelegate;
    }
    return _appConfigDelegate;
}

@end

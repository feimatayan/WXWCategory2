//
//  WDTNAccountDO.m
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/8/3.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import "WDTNAccountDO.h"


@implementation WDTNAccountDO

+ (instancetype)CopyAccount:(WDTNAccountDO *)accountDO {
    WDTNAccountDO *wdnAccountDO = [[WDTNAccountDO alloc] init];
    
    wdnAccountDO.isLogin = accountDO.isLogin;
    wdnAccountDO.duid = accountDO.duid;
    wdnAccountDO.uid = accountDO.uid;
    wdnAccountDO.shopId = accountDO.shopId;
    wdnAccountDO.loginToken = accountDO.loginToken;
    
    return wdnAccountDO;
}

@end

//
//  WDTNAccountDO.h
//  WDThorNetworking
//
//  Created by yangxin02 on 2018/8/3.
//  Copyright © 2018年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDTNAccountDO : NSObject

+ (instancetype)CopyAccount:(WDTNAccountDO *)accountDO;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSString *duid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *loginToken;

@end

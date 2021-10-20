//
//  VDUploadLibsConfig.m
//  VDUploador
//
//  Created by weidian2015090112 on 2018/11/15.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDUploadLibsConfig.h"
#import "VDFileUploader.h"

#import <WDNetwork-Base/WDNDeviceInfoUtil.h>
#import <WDNetwork-Base/WDNErrorDO.h>


@implementation VDUploadLibsConfig

+ (instancetype)sharedInstance {
    static VDUploadLibsConfig *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VDUploadLibsConfig alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [WDNDeviceInfoUtil shareUtil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(netWorkStatusChange:) name:WDNetWorkStatusChangeNOTIFICATION
                                                   object:nil];
    }
    return self;
}

- (void)netWorkStatusChange:(NSNotification *)note {
    WDNStatusChange stautsChange = [note.object integerValue];
    if (stautsChange == WDNStatusWifi2No || stautsChange == WDNStatusMobile2No) {
        [VDFileUploader cancelAllUploader:[WDNErrorDO errorWithCode:WDNHttpNoNetwork msg:@"没有网络"]];
    }
}

@end

//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WDVersion)

+ (NSString *)wd_appVersion;

+ (NSString *)wd_appBundleVersion;

+ (NSString *)wd_originDeviceModel;

+ (NSString *)wd_deviceModel;

@end

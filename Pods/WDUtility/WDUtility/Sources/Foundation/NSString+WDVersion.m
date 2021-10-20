//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import "NSString+WDVersion.h"
#import <sys/sysctl.h>

@implementation NSString (WDVersion)

+ (NSString *)wd_appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)wd_appBundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleVersionKey];
}

+ (NSString *)wd_originDeviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    
    if (!sDeviceModel || [sDeviceModel length] < 1) {
        return nil;
    }
    
    return sDeviceModel;
}

+ (NSString *)wd_deviceModel {
    NSString *sDeviceModel = [self wd_originDeviceModel];
    if (!sDeviceModel || [sDeviceModel length] < 1) {
        return nil;
    }
    
    NSDictionary *modelDict = @{@"i386"      : @"Simulator",
                                @"x86_64"    : @"Simulator",
                                @"iPhone1,1" : @"iPhone1G",
                                @"iPhone1,2" : @"iPhone3G",
                                @"iPhone2,1" : @"iPhone3GS",
                                
                                @"iPhone3,1" : @"iPhone4 AT&T",
                                @"iPhone3,2" : @"iPhone4 Other",
                                @"iPhone3,3" : @"iPhone4",
                                @"iPhone4,1" : @"iPhone4S",
                                
                                @"iPhone5,1" : @"iPhone5",
                                @"iPhone5,2" : @"iPhone5",
                                @"iPhone5,3" : @"iPhone5C",
                                @"iPhone5,4" : @"iPhone5C",
                                @"iPhone6,1" : @"iPhone5S",
                                @"iPhone6,2" : @"iPhone5S",
                                
                                @"iPhone7,1" : @"iPhone6 Plus",
                                @"iPhone7,2" : @"iPhone6",
                                
                                @"iPhone8,1" : @"iPhone 6S",
                                @"iPhone8,2" : @"iPhone 6S Plus",
                                @"iPhone8,4" : @"iPhone SE",
                                @"iPhone9,1" : @"iPhone 7 (CDMA)",
                                @"iPhone9,3" : @"iPhone 7 (GSM)",
                                @"iPhone9,2" : @"iPhone 7 Plus (CDMA)",
                                @"iPhone9,4" : @"iPhone 7 Plus (GSM)",
                                
                                @"iPod1,1"   : @"iPod1",
                                @"iPod2,1"   : @"iPod2",
                                @"iPod3,1"   : @"iPod3",
                                @"iPod4,1"   : @"iPod4",
                                
                                @"iPad1,1"   : @"iPadWiFi",
                                @"iPad1,2"   : @"iPad3G",
                                @"iPad2,1"   : @"iPad2",
                                @"iPad2,2"   : @"iPad2",
                                @"iPad2,3"   : @"iPad2",
                                @"iPad3,1"   : @"iPad3",
                                @"iPad3,4"   : @"iPad4",
                                @"iPad2,5"   : @"iPad Mini",
                                @"iPad4,4"   : @"iPad Mini 2",
                                @"iPad4,5"   : @"iPad Mini 2",
                                @"iPad4,1"   : @"iPad Air",
                                @"iPad4,2"   : @"iPad Air"
                               };
    
    NSString *deviceModelValue = [modelDict objectForKey:sDeviceModel];
    if (deviceModelValue) {
        return deviceModelValue;
    }

    return sDeviceModel;
}

@end

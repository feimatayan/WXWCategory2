//
//  UIImage+VDCFormat.m
//  VDCompress
//
//  Created by weidian2015090112 on 2018/12/21.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "UIImage+VDCFormat.h"
#import "NSData+VDCFormat.h"

#import <objc/runtime.h>


@implementation UIImage (VDCFormat)

- (BOOL)vd_opaque {
    if (!self.CGImage) {
        return NO;
    }
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    
    /// 是否有透明通道
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    
    return !hasAlpha;
}

- (VDCompressImageType)vd_imageFormat {
    VDCompressImageType imageFormat = VDCompress_Img_UNKNOW;
    NSNumber *value = objc_getAssociatedObject(self, @selector(vd_imageFormat));
    if ([value isKindOfClass:[NSNumber class]]) {
        imageFormat = value.integerValue;
        
        return imageFormat;
    }
    // Check CGImage's UTType, may return nil for non-Image/IO based image
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    if (@available(iOS 9.0, tvOS 9.0, macOS 10.11, watchOS 2.0, *)) {
        CFStringRef uttype = CGImageGetUTType(self.CGImage);
        imageFormat = [NSData vd_imageFormatFromUTType:uttype];
    }
#pragma clang diagnostic pop
    
    objc_setAssociatedObject(self, @selector(vd_imageFormat), @(imageFormat), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return imageFormat;
}

- (void)setVd_imageFormat:(VDCompressImageType)vd_imageFormat {
    // 原先有值，设置UNKNOW，直接返回
    if (vd_imageFormat == VDCompress_Img_UNKNOW
        && [self vd_imageFormat] != VDCompress_Img_UNKNOW) {
        return;
    }
    
    objc_setAssociatedObject(self, @selector(vd_imageFormat), @(vd_imageFormat), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

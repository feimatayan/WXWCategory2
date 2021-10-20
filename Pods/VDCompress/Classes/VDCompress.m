//
//  VDCompress.m
//  VDCompress
//
//  Created by weidian2015090112 on 2018/9/20.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDCompress.h"

#define kMinQuality     0.85
#define kMinSizeScale   0.85

// 默认最低质量比
static double kDefaultQuality = kMinQuality;
// 默认最低缩小比
static double kDefaultSizeScale = kMinSizeScale;


@implementation VDCompress

+ (void)quality:(double)quality scale:(double)scale {
    @synchronized (self) {
        if (quality > 1) {
            kDefaultQuality = 1;
        } else if (quality < 0) {
            kDefaultQuality = kMinQuality;
        } else {
            kDefaultQuality = quality;
        }
        
        if (scale > 1) {
            kDefaultSizeScale = 1;
        } else if (scale < kMinSizeScale) {
            kDefaultSizeScale = kMinSizeScale;
        } else {
            kDefaultSizeScale = scale;
        }
    }
}

+ (CGFloat)quality {
    return kDefaultQuality;
}

+ (double)scale {
    return kDefaultSizeScale;
}

@end

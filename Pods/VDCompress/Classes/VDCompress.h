//
//  VDCompress.h
//  VDCompress
//
//  Created by weidian2015090112 on 2018/9/20.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, VDCompressImageType) {
    VDCompress_Img_Default = -1,
    VDCompress_Img_UNKNOW = 0,
    VDCompress_Img_JPEG,
    VDCompress_Img_PNG,
    VDCompress_Img_GIF,
    VDCompress_Img_TIFF,
    VDCompress_Img_WEBP,
    VDCompress_Img_HEIC,
    VDCompress_Img_HEIF,
    VDCompress_Img_PDF,
    VDCompress_Img_SVG,
};


@interface VDCompress : NSObject


/**
 设定允许压缩的最低质量

 @param quality 图片质量，最小值
 @param scale 图片缩放比, 最小值
 */
+ (void)quality:(double)quality scale:(double)scale;

+ (CGFloat)quality;

+ (double)scale;

@end

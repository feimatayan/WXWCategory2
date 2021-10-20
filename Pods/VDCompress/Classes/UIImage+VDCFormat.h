//
//  UIImage+VDCFormat.h
//  VDCompress
//
//  Created by weidian2015090112 on 2018/12/21.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDCompress.h"


@interface UIImage (VDCFormat)

- (BOOL)vd_opaque;

- (VDCompressImageType)vd_imageFormat;

- (void)setVd_imageFormat:(VDCompressImageType)vd_imageFormat;

@end

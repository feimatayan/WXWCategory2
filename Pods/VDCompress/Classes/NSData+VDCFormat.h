//
//  NSData+VDCFormat.h
//  VDCompress
//
//  Created by weidian2015090112 on 2018/12/21.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDCompress.h"


@interface NSData (VDCFormat)

+ (VDCompressImageType)vd_imageFormatForImageData:(NSData *)data;

+ (VDCompressImageType)vd_imageFormatFromUTType:(CFStringRef)uttype;

@end

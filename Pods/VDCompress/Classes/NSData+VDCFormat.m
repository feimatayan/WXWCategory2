//
//  NSData+VDCFormat.m
//  VDCompress
//
//  Created by weidian2015090112 on 2018/12/21.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "NSData+VDCFormat.h"
#import <MobileCoreServices/MobileCoreServices.h>

// Currently Image/IO does not support WebP
//#define kVDUTTypeWebP ((__bridge CFStringRef)@"public.webp")
// AVFileTypeHEIC is defined in AVFoundation via iOS 11, we use this without import AVFoundation
//#define kVDUTTypeHEIC ((__bridge CFStringRef)@"public.heic")

// AVFileTypeHEIC/AVFileTypeHEIF is defined in AVFoundation via iOS 11, we use this without import AVFoundation
#define kVDUTTypeHEIC ((__bridge CFStringRef)@"public.heic")
#define kVDUTTypeHEIF ((__bridge CFStringRef)@"public.heif")
// HEIC Sequence (Animated Image)
#define kVDUTTypeHEICS ((__bridge CFStringRef)@"public.heics")
// kUTTypeWebP seems not defined in public UTI framework, Apple use the hardcode string, we define them :)
#define kVDUTTypeWebP ((__bridge CFStringRef)@"org.webmproject.webp")

#define kVDSVGTagEnd @"</svg>"


@implementation NSData (VDCFormat)

+ (VDCompressImageType)vd_imageFormatForImageData:(NSData *)data {
    if (!data) {
        return VDCompress_Img_UNKNOW;
    }
    
    // File signatures table: http://www.garykessler.net/library/file_sigs.html
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return VDCompress_Img_JPEG;
        case 0x89:
            return VDCompress_Img_PNG;
        case 0x47:
            return VDCompress_Img_GIF;
        case 0x49:
        case 0x4D:
            return VDCompress_Img_TIFF;
        case 0x52: {
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return VDCompress_Img_WEBP;
                }
            }
            break;
        }
        case 0x00: {
            if (data.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return VDCompress_Img_HEIC;
                }
                //....ftypmif1 ....ftypmsf1
                if ([testString isEqualToString:@"ftypmif1"] || [testString isEqualToString:@"ftypmsf1"]) {
                    return VDCompress_Img_HEIF;
                }
            }
            break;
        }
        case 0x25: {
            if (data.length >= 4) {
                //%PDF
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(1, 3)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"PDF"]) {
                    return VDCompress_Img_PDF;
                }
            }
        }
        case 0x3C: {
            // Check end with SVG tag
            if ([data rangeOfData:[kVDSVGTagEnd dataUsingEncoding:NSUTF8StringEncoding] options:NSDataSearchBackwards range: NSMakeRange(data.length - MIN(100, data.length), MIN(100, data.length))].location != NSNotFound) {
                return VDCompress_Img_SVG;
            }
        }
    }
    return VDCompress_Img_Default;
}

+ (VDCompressImageType)vd_imageFormatFromUTType:(CFStringRef)uttype {
    if (!uttype) {
        return VDCompress_Img_UNKNOW;
    }
    
    VDCompressImageType imageFormat;
    if (CFStringCompare(uttype, kUTTypeJPEG, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_JPEG;
    } else if (CFStringCompare(uttype, kUTTypePNG, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_PNG;
    } else if (CFStringCompare(uttype, kUTTypeGIF, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_GIF;
    } else if (CFStringCompare(uttype, kUTTypeTIFF, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_TIFF;
    } else if (CFStringCompare(uttype, kVDUTTypeWebP, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_WEBP;
    } else if (CFStringCompare(uttype, kVDUTTypeHEIC, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_HEIC;
    } else if (CFStringCompare(uttype, kVDUTTypeHEIF, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_HEIF;
    } else if (CFStringCompare(uttype, kUTTypePDF, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_PDF;
    } else if (CFStringCompare(uttype, kUTTypeScalableVectorGraphics, 0) == kCFCompareEqualTo) {
        imageFormat = VDCompress_Img_SVG;
    } else {
        imageFormat = VDCompress_Img_Default;
    }
    
    // kUTTypeBMP
    // 还有好多
    
    return imageFormat;
}

@end

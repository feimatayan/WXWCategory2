//
//  UIImage+VDCompress.m
//  VDCompress
//
//  Created by weidian2015090112 on 2018/9/20.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "UIImage+VDCompress.h"
#import "UIImage+VDCFormat.h"
#import "NSData+VDCFormat.h"

#import "VDCompress.h"
#import "VDCompressUT.h"


@implementation UIImage (VDCompress)

+ (void)vd_compressImageData:(NSData *)imageData
                       level:(VDCompressLevel)level
                     quality:(CGFloat)quality
                   imageSize:(CGSize)imageSize
                 maxFileSize:(NSInteger)fileSize
                    callback:(void (^)(NSData *))callback
{
    if (!imageData) {
        !callback ?: callback(nil);
    }
    
    VDCompressImageType imageType = [NSData vd_imageFormatForImageData:imageData];
    if (imageType == VDCompress_Img_GIF) {
        !callback ?: callback(imageData);
    } else {
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            [self vd_compressImage:image
                             level:level
                           quality:quality
                         imageSize:imageSize
                       maxFileSize:fileSize
                          callback:callback];
        } else {
            !callback ?: callback(nil);
        }
    }
}

+ (void)vd_compressImage:(UIImage *)image
                   level:(VDCompressLevel)level
                 quality:(CGFloat)quality
               imageSize:(CGSize)imageSize
             maxFileSize:(NSInteger)fileSize
                callback:(void (^)(NSData *))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!image) {
            !callback ?: callback(nil);
        }
        
        NSData *compressData = [image vd_compressWithLevel:level
                                                   quality:quality
                                                 imageSize:imageSize
                                               maxFileSize:fileSize];
        
        if (callback) {
            callback(compressData);
        }
    });
}

- (NSData *)vd_compressWithLevel:(VDCompressLevel)level
                     maxFileSize:(NSInteger)fileSize
{
    return [self vd_compressWithLevel:level
                              quality:[VDCompress quality]
                            imageSize:CGSizeZero
                          maxFileSize:fileSize];
}

- (NSData *)vd_compressWithLevel:(VDCompressLevel)level
                         quality:(CGFloat)quality
                     maxFileSize:(NSInteger)fileSize
{
    return [self vd_compressWithLevel:level
                              quality:quality
                            imageSize:CGSizeZero
                          maxFileSize:fileSize];
}

- (NSData *)vd_compressWithLevel:(VDCompressLevel)level
                         quality:(CGFloat)quality
                       imageSize:(CGSize)imageSize
                     maxFileSize:(NSInteger)fileSize
{
    // ut
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    UIImage *image = self;
    // 最原始的图片类型
    VDCompressImageType imageType = [image vd_imageFormat];
    
    // level
    if (level != VDCompressLevel_Original) {
        CGFloat maxWdith = level;
        if (maxWdith < 700) {
            maxWdith = 700;
        }
        
        if (image.size.width > maxWdith) {
            CGSize newSize;
            newSize.width = maxWdith;
            if (image.size.width <= 0) {
                newSize.height = floorf(maxWdith / 0.618);
            } else {
                newSize.height = floorf(image.size.height * maxWdith / image.size.width);
            }

            UIGraphicsBeginImageContextWithOptions(newSize, [self vd_opaque], image.scale);
            [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [image setVd_imageFormat:imageType];
        }
    }
    
    VDCompressUTDO *utDO = [VDCompressUTDO new];
    NSData *result = [image vd_compressWithMaxFileSize:fileSize
                                               quality:quality
                                             imageSize:imageSize
                                                    ut:utDO];
    
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *sourceData = [self vdp_UIImageRepresentation:1];
        utDO.sourceFileSize = sourceData.length;
        utDO.sourceImgSize = self.size;
        if (result) {
            UIImage *compressImage = [UIImage imageWithData:result scale:image.scale];
            
            utDO.compressFileSize = result.length;
            utDO.compressImgSize = compressImage.size;
        }
        
        utDO.maxFileSize = fileSize;
        utDO.maxWidth = imageSize.width;
        utDO.maxHeight = imageSize.height;
        
        [VDCompressUT vdUT_success:result ? YES : NO
                              time:(endTime - startTime) * 1000
                              args:utDO];
    });
    
    if (!result || result.length == 0) {
        return [image vdp_UIImageRepresentation:1];
    }
    
    return result;
}

#pragma mark - PNG

- (NSData *)vdp_UIImageRepresentation:(CGFloat)quality {
    if ([self vd_imageFormat] == VDCompress_Img_PNG) {
        return UIImagePNGRepresentation(self);
    }
    
    return UIImageJPEGRepresentation(self, quality);
}

#pragma mark - Private

- (NSData *)vd_compressWithMaxFileSize:(NSInteger)fileSize
                               quality:(CGFloat)quality
                             imageSize:(CGSize)imageSize
                                    ut:(VDCompressUTDO *)ut
{
    UIImage *image = self;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        // 用户没有尺寸要求
    } else {
        // 如果用户有指定需要缩放到指定大小
        // 优先保证图片质量
        image = [image vdp_compressBySize:imageSize fileSize:0];
    }
    
    NSData *data = [image vdp_UIImageRepresentation:1];
    // 尺寸已经满足，大小也满足，quality也满足要求
    if (data.length < fileSize && quality >= 1) {
        return data;
    }
    
    CGFloat defaultQ = [VDCompress quality];
    if (quality < defaultQ) {
        quality = defaultQ;
        
        // 在quality - 1之间找最优的压缩
        data = [image vdp_compressByQuality:defaultQ fileSize:fileSize ut:ut];
    } else if (quality <= 1) {
        data = quality < 1 ? [image vdp_UIImageRepresentation:quality] : data;
    } else {
        quality = 1;
    }
    
    // 保存一下，最后用
    NSData *originData = data;
    
    if (data.length > fileSize) {
        // 质量和尺寸压缩后都没达到要求，抛弃质量要求，按压缩尺寸
        image = [image vdp_compressBySize:CGSizeZero fileSize:fileSize];
        data = [image vdp_UIImageRepresentation:1];
        
        // 最后一次机会，再损失点质量
        if (data.length > fileSize) {
            data = quality < 1 ? [image vdp_compressByQuality:quality
                                                     fileSize:fileSize
                                                           ut:ut] : data;
        }
        
        //透明图片，缩放后变大了，可能压缩的方法不对，需要底层C的方法，暂时不替换了
        if (data.length > originData.length) {
            data = originData;
        }
    }
    
    return data;
}


/// 指定quality压缩，在quality和1之间循环压缩
/// @param quality 最小值
/// @param fileSize 限制大小
/// @param ut 埋点
- (NSData *)vdp_compressByQuality:(CGFloat)quality
                         fileSize:(NSInteger)fileSize
                               ut:(VDCompressUTDO *)ut
{
    NSData *maxData = [self vdp_UIImageRepresentation:1];
    if (maxData.length < fileSize || quality >= 1) {
        return maxData;
    }
    
    CGFloat max = 1;
    CGFloat min = quality;
    
    NSData *data;
    if ([self vd_imageFormat] == VDCompress_Img_PNG) {
        ut.quality = 0;
        
        data = [self vdp_UIImageRepresentation:0];
    } else {
        CGFloat compressQ;
        for (int i = 0; i < 6; ++i) {
            compressQ = (max + min) / 2.0;
            data = [self vdp_UIImageRepresentation:compressQ];
            ut.quality = compressQ;
            if (data.length < fileSize * 0.9) {
                min = compressQ;
            } else if (data.length > fileSize) {
                max = compressQ;
            } else {
                break;
            }
        }
    }
    
    if (data.length > fileSize) {
        // 这种情况是，最小压缩比就已经超过了限制大小
        [self vdp_UIImageRepresentation:quality];
    }
    
    return data;
}


/// 指定尺寸压缩压缩，如果imageSize是空的，不需要fileSize，只是缩放
/// @param imageSize 指定尺寸
/// @param fileSize 指定字节大小
- (UIImage *)vdp_compressBySize:(CGSize)imageSize fileSize:(NSInteger)fileSize
{
    UIImage *resultImage = self;
    VDCompressImageType imageType = [resultImage vd_imageFormat];
    
    CGSize size = CGSizeMake(resultImage.size.width, resultImage.size.height);
    if (size.width == 0 || size.height == 0) {
        return resultImage;
    }
    
    NSData *resultData = [resultImage vdp_UIImageRepresentation:1];
    
    if (imageSize.width == 0 && imageSize.height == 0) {
        NSUInteger runCount = 0;
        NSUInteger lastDataLength = resultData.length + 1;
        // 压缩到指定大小后跳出循环
        // 连续两次压缩没有变小，跳出循环
        while (resultData.length > fileSize && resultData.length < lastDataLength) {
            lastDataLength = resultData.length;
            
            CGFloat ratio = sqrtf((CGFloat)fileSize / resultData.length);
            if (runCount > 2) {
                ratio = (CGFloat)fileSize / resultData.length;
            }
            size = CGSizeMake((NSInteger)(size.width * ratio), (NSInteger)(size.height * ratio));
            
            UIGraphicsBeginImageContextWithOptions(size, [self vd_opaque], self.scale);
            [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [resultImage setVd_imageFormat:imageType];
            resultData = [resultImage vdp_UIImageRepresentation:1];
            
            runCount++;
            if (runCount > 6) {
                return resultImage;
            }
        }
    } else {
        CGFloat limitWidth = imageSize.width / self.scale;
        CGFloat limitHeight = imageSize.height / self.scale;
        
        CGFloat ratio = 1;
        if (limitWidth > 0 && limitHeight == 0) {
            // 已宽度为准
            ratio = limitWidth < size.width;
        } else if (limitWidth == 0 && limitHeight > 0) {
            // 已高度为准
            ratio = limitHeight < size.height;
        } else {
            // 缩小到规定的size内
            ratio = MIN(limitWidth / size.width, limitHeight / size.height);
        }
        
        if (ratio < 1) {
            size = CGSizeMake(size.width * ratio, size.height * ratio);
            
            UIGraphicsBeginImageContextWithOptions(size, [self vd_opaque], self.scale);
            [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [resultImage setVd_imageFormat:imageType];
        }
    }
    
    return resultImage;
}

@end

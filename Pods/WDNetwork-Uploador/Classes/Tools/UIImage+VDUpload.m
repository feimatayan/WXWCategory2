//
//  UIImage+VDUpload.m
//  WDNetwork-Uploador
//
//  Created by 杨鑫 on 2021/5/26.
//

#import "UIImage+VDUpload.h"

#import <VDCompress/UIImage+VDCFormat.h>

#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>

#import <MobileCoreServices/MobileCoreServices.h>


NSString * const AnimatedGIFImageErrorDomain = @"com.compuserve.gif.image.error";


@implementation UIImage (VDUpload)

+ (UIImage *)vd_imageWithData:(NSData *)data {
    UIImage *image;
    
    SDImageCoderOptions *options = @{
        SDImageCoderDecodeScaleFactor : @(1),
        SDImageCoderDecodeFirstFrameOnly : @(NO)
    };
    
    SDImageFormat imgFormat = [NSData sd_imageFormatForImageData:data];
    switch (imgFormat) {
        case SDImageFormatGIF:
            image = [[SDImageGIFCoder sharedCoder] decodedImageWithData:data options:options];
//            [image setVd_imageFormat:VDCompress_Img_GIF];
            break;
        case SDImageFormatWebP:
            image = [[SDImageWebPCoder sharedCoder] decodedImageWithData:data options:options];
            
            // 格式会丢失，这里补一下
            [image setVd_imageFormat:VDCompress_Img_WEBP];
            break;
        case SDImageFormatJPEG:
            image = [UIImage imageWithData:data];
//            [image setVd_imageFormat:VDCompress_Img_JPEG];
            break;
        case SDImageFormatPNG:
            image = [[SDImageAPNGCoder sharedCoder] decodedImageWithData:data options:options];
//            [image setVd_imageFormat:VDCompress_Img_PNG];
            break;
        case SDImageFormatHEIC:
            image = [[SDImageHEICCoder sharedCoder] decodedImageWithData:data options:options];
//            [image setVd_imageFormat:VDCompress_Img_HEIC];
            break;
        case SDImageFormatHEIF:
            image = [[SDImageHEICCoder sharedCoder] decodedImageWithData:data options:options];
//            [image setVd_imageFormat:VDCompress_Img_HEIF];
            break;
    }
    
    if (!image || !image.CGImage) {
        options = @{
            SDImageCoderDecodeScaleFactor : @(1),
            SDImageCoderDecodeFirstFrameOnly : @(YES)
        };
        
        image = [[SDImageIOCoder sharedCoder] decodedImageWithData:data options:options];
    }
    
    if (!image || !image.CGImage) {
        image = [UIImage imageWithData:data];
    }
    
    return image;
}

/*
+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString*)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.

    if (frameDuration < 0.011f)
        frameDuration = 0.100f;

    CFRelease(cfFrameProperties);
    return frameDuration;
}*/

@end


__attribute__((overloadable)) NSData * _Nullable VDUIImageDefaultRepresentation(UIImage *image) {
    NSData *imageData;
    
    SDImageFormat imgFormat = image.sd_imageFormat;
    switch (imgFormat) {
        case SDImageFormatGIF:
            imageData = VDUIImageAnimatedGIFRepresentation(image);
            break;
        case SDImageFormatWebP:
            imageData = VDUIImageWebpRepresentation(image);
            break;
        case SDImageFormatJPEG:
            imageData = UIImageJPEGRepresentation(image, 1);
            break;
        case SDImageFormatPNG: {
            if (image.images) {
                imageData = VDUIImageAPNGRepresentation(image);
            } else {
                imageData = UIImagePNGRepresentation(image);
            }
        } break;
        case SDImageFormatHEIC:
        case SDImageFormatHEIF:
            imageData = VDUIImageHEICRepresentation(image);
            break;
    }
    
    if (imageData == nil) {
        SDImageCoderOptions *options = @{
            SDImageCoderEncodeCompressionQuality : @(1),
            SDImageCoderEncodeFirstFrameOnly : @(YES)
        };
        
        imageData = [[SDImageIOCoder sharedCoder] encodedDataWithImage:image format:imgFormat options:options];
    }
    
    if (imageData == nil) {
        if ([SDImageCoderHelper CGImageContainsAlpha:image.CGImage]) {
            imageData = UIImagePNGRepresentation(image);
        } else {
            imageData = UIImageJPEGRepresentation(image, 1);
        }
    }
    
    return imageData;
}

__attribute__((overloadable)) NSData * _Nullable VDUIImageAnimatedGIFRepresentation(UIImage *image) {
//    return UIImageAnimatedGIFRepresentation(image, 0.0, 0, nil);
    
    SDImageCoderOptions *options = @{
        SDImageCoderEncodeCompressionQuality : @(1),
        SDImageCoderEncodeFirstFrameOnly : @(NO)
    };
    
    return [[SDImageGIFCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatGIF options:options];
}

__attribute__((overloadable)) NSData * _Nullable VDUIImageWebpRepresentation(UIImage *image) {
    SDImageCoderOptions *options = @{
        SDImageCoderEncodeCompressionQuality : @(1),
        SDImageCoderEncodeFirstFrameOnly : @(NO)
    };
    
    return [[SDImageWebPCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatWebP options:options];
}

__attribute__((overloadable)) NSData * _Nullable VDUIImageAPNGRepresentation(UIImage *image) {
    SDImageCoderOptions *options = @{
        SDImageCoderEncodeCompressionQuality : @(1),
        SDImageCoderEncodeFirstFrameOnly : @(NO)
    };
    
    return [[SDImageAPNGCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatPNG options:options];
}

__attribute__((overloadable)) NSData * _Nullable VDUIImageHEICRepresentation(UIImage *image) {
    SDImageCoderOptions *options = @{
        SDImageCoderEncodeCompressionQuality : @(1),
        SDImageCoderEncodeFirstFrameOnly : @(NO)
    };
    
    return [[SDImageHEICCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatHEIC options:options];
}

/// 自己写了下，方法都差不多，但是调不好，想想还是用SD的方法的吧。
/*
__attribute__((overloadable)) NSData * _Nullable UIImageAnimatedGIFRepresentation(UIImage *image, NSTimeInterval duration, NSUInteger loopCount, NSError * __autoreleasing *error) {
    if (!image) {
        return nil;
    }
    
    NSArray<UIImage *> *images = image.images;
    if (!images) {
        images = @[image];
    }

    NSDictionary *userInfo = nil;
    {
        size_t frameCount = images.count;
        
        NSTimeInterval imageDuration = image.duration;
        if (duration > 0) {
            imageDuration = duration;
        }
        
        NSTimeInterval frameDuration = imageDuration / frameCount;
        
        NSUInteger frameDelayCentiseconds = (NSUInteger)lrint(frameDuration * 100);
        NSDictionary<NSString *, id> *frameProperties = @{
            (__bridge NSString *)kCGImagePropertyGIFDictionary: @{(__bridge NSString *)kCGImagePropertyGIFDelayTime: @(frameDelayCentiseconds)}
        };

        NSMutableData *mutableData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, frameCount, NULL);

        NSDictionary<NSString *, id> *imageProperties = @{
            (__bridge NSString *)kCGImagePropertyGIFDictionary: @{(__bridge NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)}
        };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);

        for (size_t idx = 0; idx < images.count; idx++) {
            UIImage *frameImage = images[idx];
            CGImageRef _Nullable cgimage = [frameImage CGImage];
            if (cgimage) {
                CGImageDestinationAddImage(destination, (CGImageRef _Nonnull)cgimage, (__bridge CFDictionaryRef)frameProperties);
            }
        }

        BOOL success = CGImageDestinationFinalize(destination);
        CFRelease(destination);

        if (!success) {
            userInfo = @{
                NSLocalizedDescriptionKey: NSLocalizedString(@"Could not finalize image destination", nil)
            };

            goto _error;
        }

        return [NSData dataWithData:mutableData];
    }
    _error: {
        if (error) {
            *error = [[NSError alloc] initWithDomain:AnimatedGIFImageErrorDomain code:-1 userInfo:userInfo];
        }

        return nil;
    }
}
 */

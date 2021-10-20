//
// Created by Henson on 10/9/15.
// Copyright (c) 2015 Henson. All rights reserved.
//

#import "UIImage+WDUIKit.h"

@implementation UIImage (WDUIKit)

+ (UIImage *)wd_imageWithFileName:(NSString *)fileName {
    if (!fileName || [fileName length] < 1) {
        return nil;
    }
    
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
    NSString *imagePath = [imageFolderPath stringByAppendingString:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (UIImage *)wd_imageWithColor:(UIColor *)color {
    return [self wd_imageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)wd_imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect) {.size = size});
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

+ (UIImage *)wd_scaleImageWithWidth:(CGFloat)width height:(CGFloat)height image:(UIImage *)image {
    if (width == 640)
    {
        // item image
        if (image.size.width < width)
        {
            return image;
        }
        else
        {
            CGSize newSize;
            newSize.width  = width;
            newSize.height = (image.size.height * width) / image.size.width;
            newSize.height = floorf(newSize.height);
            
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return scaledImage;
        }
    }
    else
    {
        // 图片比需求的尺寸小，直接返回原图片
        if (image.size.width < width)
        {
            return image;
        }
        
        CGSize newSize;
        newSize.width  = width;
        newSize.height = height;
        newSize.height = floorf(newSize.height);
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;
    }
}

- (UIImage *)wd_scaleToSize:(CGSize)size {
    CGFloat h = self.size.height;
    CGFloat w = self.size.width;
    if (h <= size.width && w <= size.height) {
        return self;
    }
    
    float b = (float)size.width/w < (float)size.height/h ? (float)size.width/w : (float)size.height/h;
    CGSize itemSize = CGSizeMake(b*w, b*h);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0);
    
    CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
    [self drawInRect:imageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)wd_aspectScaleToSize:(CGSize)size {
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat hScaleFactor = imageSize.width / size.width;
    CGFloat vScaleFactor = imageSize.height / size.height;
    
    CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
    
    CGFloat newWidth = imageSize.width   / scaleFactor;
    CGFloat newHeight = imageSize.height / scaleFactor;
    
    CGFloat leftOffset = (size.width - newWidth) / 2;
    CGFloat topOffset = (size.height - newHeight) / 2;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    }
    
    [self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)wd_aspectFillScaleToSize:(CGSize)size {
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat hScaleFactor = imageSize.width / size.width;
    CGFloat vScaleFactor = imageSize.height / size.height;
    
    CGFloat scaleFactor = MIN(hScaleFactor, vScaleFactor);
    
    CGFloat newWidth = imageSize.width   / scaleFactor;
    CGFloat newHeight = imageSize.height / scaleFactor;
    
    CGFloat leftOffset = (size.width - newWidth) / 2;
    CGFloat topOffset = (size.height - newHeight) / 2;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    }
    
    [self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage*)wd_scaleToFitMaxWidth:(CGFloat)maxWidth {
    CGSize szImage = self.size;
    if (szImage.width < maxWidth) {
        return self;
    } else {
        CGSize newSize;
        newSize.width  = maxWidth;
        newSize.height = (maxWidth/szImage.width)* szImage.height;
        newSize.height = floorf(newSize.height);
        
        return [self wd_scaleToSize:newSize];
    }
}

- (UIImage*)wd_scaleToFitMaxHeight:(CGFloat)maxHeight {
    CGSize szImage = self.size;
    if (szImage.height < maxHeight) {
        return self;
    } else {
        CGSize newSize;
        newSize.height  = maxHeight;
        newSize.width = (maxHeight/szImage.height)* szImage.width;
        newSize.width = floorf(newSize.width);
        
        return [self wd_scaleToSize:newSize];
    }
}

@end

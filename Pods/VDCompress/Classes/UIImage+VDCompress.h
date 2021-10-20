//
//  UIImage+VDCompress.h
//  VDCompress
//
//  Created by weidian2015090112 on 2018/9/20.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, VDCompressLevel) {
    VDCompressLevel_Original = 1,
    VDCompressLevel_2000 = 2000,
    VDCompressLevel_1500 = 1500,
    
    // 1242, iphoneXS Max
    VDCompressLevel_XSMAX = 1200,
    // 1125, iphoneX, iphoneXS
    VDCompressLevel_X = 1100,
    // 1080, 8p
    VDCompressLevel_Plus = 1000,
    // 750, 8
    VDCompressLevel_700 = 700,
};


/**
 Gif暂时不要用UIImage传过来压缩，Gif下，UIImage和NSData的互转还没有开发；
 如果是Gif，请调用vd_compressImageData: ... 方法
 */
@interface UIImage (VDCompress)

/**
 图片异步压缩方法, 图片是Gif，使用这个方法
 
 规则步骤;
 1. 根据level缩放到指定的宽度，宽度不够跳过这一步；
 2. 有imageSize要求，先缩放到imageSize的框内;
 3. 如果已经满足fileSize且quality>=1，直接返回；
 4.   quality<[VDCompress quality]，quality=[VDCompress quality]，在quality-1之间找失真最小的压缩；
    quality>1，quality=1，直接用quality；
 5. 如果已经满足fileSize，直接返回；
 6. 用第4步之前的图片进行，循环缩放找到满足fileSize的最大图片；
 7. 如果已经满足fileSize，直接返回；
 8. 在quality-1之间找失真最小的压缩，直接返回；
 9. 注意：透明图片裁剪之后可能会变大，应该是代码问题，估计要找开源的C的压缩库实现，暂时不管了
 
 这样既满足了尺寸的要求，也保证了图片的质量
 
 @param imageData 原始Data
 @param level 图片压缩等级，按iphone屏幕宽度分级
 @param quality 压缩比，如果是0，默认采用大小限制bb内的最高压缩比)
 @param imageSize 限制图片尺寸大小，请使用物理像素
 @param fileSize 限制图片大小 (文件硬盘大小: 6 * 1024 * 1024)
 @param callback 回调
 */
+ (void)vd_compressImageData:(NSData *)imageData
                       level:(VDCompressLevel)level
                     quality:(CGFloat)quality
                   imageSize:(CGSize)imageSize
                 maxFileSize:(NSInteger)fileSize
                    callback:(void (^)(NSData *))callback;

/**
 图片异步压缩方法
 
 规则步骤;
 1. 根据level缩放到指定的宽度，宽度不够跳过这一步；
 2. 有imageSize要求，先缩放到imageSize的框内;
 3. 如果已经满足fileSize且quality>=1，直接返回；
 4.   quality<[VDCompress quality]，quality=[VDCompress quality]，在quality-1之间找失真最小的压缩；
    quality>1，quality=1，直接用quality；
 5. 如果已经满足fileSize，直接返回；
 6. 用第4步之前的图片进行，循环缩放找到满足fileSize的最大图片；
 7. 如果已经满足fileSize，直接返回；
 8. 在quality-1之间找失真最小的压缩，直接返回；
 
 这样既满足了尺寸的要求，也保证了图片的质量

 @param image 原始图片
 @param level 图片压缩等级，按iphone屏幕宽度分级
 @param quality 压缩比，如果是0，默认采用大小限制bb内的最高压缩比)
 @param imageSize 限制图片尺寸大小，请使用物理像素
 @param fileSize 限制图片大小 (文件硬盘大小: 6 * 1024 * 1024)
 @param callback 回调
 */
+ (void)vd_compressImage:(UIImage *)image
                   level:(VDCompressLevel)level
                 quality:(CGFloat)quality
               imageSize:(CGSize)imageSize
             maxFileSize:(NSInteger)fileSize
                callback:(void (^)(NSData *))callback;

/**
 压缩, 使用默认压缩比
 
 @param level 图片压缩等级，按iphone屏幕宽度分级
 @param fileSize 限制图片大小 (文件硬盘大小: 6 * 1024 * 1024)
 @return data
 */
- (NSData *)vd_compressWithLevel:(VDCompressLevel)level
                     maxFileSize:(NSInteger)fileSize;

/**
 压缩, 指定压缩比
 imageSize是CGSizeZero
 
 规则步骤;
 1. 根据level缩放到指定的宽度，宽度不够跳过这一步；
 2. 有imageSize要求，先缩放到imageSize的框内;
 3. 如果已经满足fileSize且quality>=1，直接返回；
 4.   quality<[VDCompress quality]，quality=[VDCompress quality]，在quality-1之间找失真最小的压缩；
    quality>1，quality=1，直接用quality；
 5. 如果已经满足fileSize，直接返回；
 6. 用第4步之前的图片进行，循环缩放找到满足fileSize的最大图片；
 7. 如果已经满足fileSize，直接返回；
 8. 在quality-1之间找失真最小的压缩，直接返回；
 
 这样既满足了尺寸的要求，也保证了图片的质量
 
 @param level 图片压缩等级，按iphone屏幕宽度分级
 @param quality 压缩比，如果是0，默认采用大小限制bb内的最高压缩比)
 @param fileSize 限制图片大小 (文件硬盘大小: 6 * 1024 * 1024)
 @return data
 */
- (NSData *)vd_compressWithLevel:(VDCompressLevel)level
                         quality:(CGFloat)quality
                     maxFileSize:(NSInteger)fileSize;


/**
 因为iphone拍出的照片都太大了，基本是3k*4k
 修改一下压缩逻辑，先对尺寸压缩，压缩选项是枚举, 然后再质量压缩，如果还太大，就再压缩尺寸.
 
 规则步骤;
 1. 根据level缩放到指定的宽度，宽度不够跳过这一步；
 2. 有imageSize要求，先缩放到imageSize的框内;
 3. 如果已经满足fileSize且quality>=1，直接返回；
 4.   quality<[VDCompress quality]，quality=[VDCompress quality]，在quality-1之间找失真最小的压缩；
    quality>1，quality=1，直接用quality；
 5. 如果已经满足fileSize，直接返回；
 6. 用第4步之前的图片进行，循环缩放找到满足fileSize的最大图片；
 7. 如果已经满足fileSize，直接返回；
 8. 在quality-1之间找失真最小的压缩，直接返回；
 
 这样既满足了尺寸的要求，也保证了图片的质量

 @param level 图片压缩等级，按iphone屏幕宽度分级
 @param quality 压缩比，如果是0，默认采用大小限制bb内的最高压缩比)
 @param imageSize 限制图片尺寸大小，请使用物理像素
 @param fileSize 限制图片大小 (文件硬盘大小: 6 * 1024 * 1024)
 @return data
 */
- (NSData *)vd_compressWithLevel:(VDCompressLevel)level
                         quality:(CGFloat)quality
                       imageSize:(CGSize)imageSize
                     maxFileSize:(NSInteger)fileSize;

@end

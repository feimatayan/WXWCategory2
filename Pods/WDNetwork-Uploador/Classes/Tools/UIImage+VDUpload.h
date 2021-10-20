//
//  UIImage+VDUpload.h
//  WDNetwork-Uploador
//
//  Created by 杨鑫 on 2021/5/26.
//

#import <UIKit/UIKit.h>


extern NSString * const AnimatedGIFImageErrorDomain;


@interface UIImage (VDUpload)


/// SVG、tmp文件暂时不支持
/// @param data NSData
+ (UIImage *)vd_imageWithData:(NSData *)data;

@end


/// 通用方法
/// SVG、tmp文件暂时不支持
/// @param data NSData
/// @param image UIImage
extern __attribute__((overloadable)) NSData * _Nullable VDUIImageDefaultRepresentation(UIImage *image);

/// 将Gif的UIImage转化为NSData
/// @param image UIImage
extern __attribute__((overloadable)) NSData * _Nullable VDUIImageAnimatedGIFRepresentation(UIImage *image);


/// 将webp的UIImage转化为NSData
/// @param image UIImage
extern __attribute__((overloadable)) NSData * _Nullable VDUIImageWebpRepresentation(UIImage *image);


/// 动态的png编码
/// @param image UIImage
extern __attribute__((overloadable)) NSData * _Nullable VDUIImageAPNGRepresentation(UIImage *image);


/// 苹果设备的格式
/// @param image UIImage
extern __attribute__((overloadable)) NSData * _Nullable VDUIImageHEICRepresentation(UIImage *image);


/// 将Gif的UIImage转化为gif
/// @param image UIImage
/// @param duration 播放时间
/// @param loopCount 循环次数
/// @param error NSError
//extern __attribute__((overloadable)) NSData * _Nullable UIImageAnimatedGIFRepresentation(UIImage *image, NSTimeInterval duration, NSUInteger loopCount, NSError * __autoreleasing *error);

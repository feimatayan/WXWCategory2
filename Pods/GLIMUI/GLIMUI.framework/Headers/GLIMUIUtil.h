//
//  GLIMUIUtil.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMUIScreenAdapter(point)        ([GLIMUIUtil adapterPoint:point])
#define IMUIFontAdapter(fontSize)       ([GLIMUIUtil adapterFontSize:fontSize isBold:NO])
#define IMUIFontBoldAdapter(fontSize)   ([GLIMUIUtil adapterFontSize:fontSize isBold:YES])


@interface GLIMUIUtil : NSObject

+ (UIWindow*)appWindow;

+ (UIWindow *)appKeyWindow;

/**
 获取app的主导航栏

 @return 主导航栏
 */
+ (UINavigationController *)appNavigationController;

/**
 获取当前使用的导航栏

 @return 当前使用的导航栏
 */
+ (UINavigationController *)currentNavigationController;

/**
 为指定viewController生成新的导航栏

 @param viewController 指定viewController
 @return 新的导航栏
 */
+ (UINavigationController *)navigationControllerWithViewController:(UIViewController *)viewController;

/**
 获取指定名称的图片

 @param imageName 图片名称
 @return 图片对象
 */
+ (UIImage*)imageFromBundleByName:(NSString*)imageName;

/**
 获取指定Bundle路径中的图片

 @param imageName 图片名称
 @param bundleName bundle名称
 @return 图片对象
 */
+ (UIImage *)imageWithName:(NSString *)imageName inBundle:(NSString *)bundleName;

/// 从Bundle中获取plist文件
+ (NSString *)fullPathFromBundleByName:(NSString *)fileName;
/// TODO: 获取大表情图片，暂时先存在这，不实现
+ (UIImage *)imageFromCacheByName:(NSString *)imageName;

/// 适配字体
+ (UIFont *)adapterFontSize:(CGFloat)fontsize isBold:(BOOL)isBold;
/// 适配点
+ (NSInteger)adapterPoint:(CGFloat)point;


/**
 获取指定字体的文本尺寸

 @param string          文本内容
 @param font            字体大小
 @param constraintSize  限定尺寸
 @return                实际尺寸
 */
+ (CGRect)rectForString:(NSString *)string
               withFont:(UIFont *)font
         constraintSize:(CGSize)constraintSize;


/**
 根据原图片链接生成指定方图链接

 @param originalUrl 图片原链接
 @return 指定链接
 */
+ (NSString *)squareImageUrlWithOriginalUrl:(NSString *)originalUrl width:(CGFloat)width;

+ (NSString *)squareImageUrlWithOriginalUrl:(NSString *)originalUrl width:(CGFloat)width height:(CGFloat)height;

+ (NSString *)combinationUrl:(NSString *)urlString widthDic:(NSDictionary *)query;

@end

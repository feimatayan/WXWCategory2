//
//  UIImage+WDExtensions.h
//  GLImageProcessor
//
//  Created by wangli on 15/12/9.
//  Copyright © 2015年 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WDExtensions)


/********************************************
 *
 * @brief 图片顺时针旋转
 *
 * @param degrees 旋转角度
 *
 * @return 旋转后的图片
 *
 *******************************************/
- (UIImage *)rotateByDegrees:(CGFloat)degrees;

/**************************
 *
 * @brief 保存图片到系统相册
 *
 *************************/
- (void)saveToAlbum;

@end

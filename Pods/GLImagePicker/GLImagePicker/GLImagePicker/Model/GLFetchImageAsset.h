//
//  GLFetchImageAsset.h
//  GLUIKit
//
//  Created by xiaofengzheng on 3/14/16.
//  Copyright © 2016 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHAsset.h>
#import <AssetsLibrary/ALAsset.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    /// 选择
    GLFetchImageAssetClickTypeSelect,
    /// 预览
    GLFetchImageAssetClickTypePreview,
    
} GLFetchImageAssetClickType;



@interface GLFetchImageAsset : NSObject


/// store data PHAsset or ALAsset
@property (nonatomic, strong) id    data;   
/// default NO
@property (nonatomic, assign) BOOL              isSelected;
/// store click type
@property (nonatomic, assign) GLFetchImageAssetClickType  clickType;
/// PHAsset fullScreenImage 的下载进度
@property (nonatomic, assign) CGFloat           progress;
/// PHAsset fullScreenImage
@property (nonatomic, strong) UIImage           *fullScreenImage;
@property (nonatomic, strong) UIImage           *imageEditing; // 正在编辑的图片
/// gif图片数据
@property (nonatomic, strong) NSData *gifData;

@property (nonatomic, assign) BOOL isGIF;

@property (nonatomic, assign) NSUInteger index;




/**
 *  用PHAsset实例化一个GLFetchImageAsset 对象
 *
 */
+ (GLFetchImageAsset *)getFetchImageAsseWithPHAsset:(PHAsset *)phAsset;


/**
 *  用ALAsset实例化一个GLFetchImageAsset 对象
 *
 */
+ (GLFetchImageAsset *)getFetchImageAsseWithALAsset:(ALAsset *)alAsset;







@end

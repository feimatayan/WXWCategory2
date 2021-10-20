//
//  GLAssetsPreviewViewController.h
//  WDCommlib
//
//  Created by xiaofengzheng on 12/17/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import <GLUIKit/GLUIKit.h>
#import <Photos/Photos.h>

@class GLFetchImageAsset;
@class GLFetchImageConfig;

typedef void(^clickSelectBlock)(void);
typedef void(^clickFinishBlock)(void);
typedef BOOL(^clickCheckBlock)(GLFetchImageAsset *);

// 预览图片类型
typedef NS_ENUM(NSInteger, GLAssetsPreviewType) {
    GLAssetsPreviewSelected = 0, // 预览选中图片
    GLAssetsPreviewAll          //
};


@interface GLAssetsPreviewViewController : GLViewController


@property (nonatomic, assign) GLAssetsPreviewType previewType;
/// 最大选择数
@property (nonatomic, assign) NSInteger     maxSelectedCount;
/// 当前展示的
@property (nonatomic, retain) GLFetchImageAsset *currentShowAsset;

/// 列表界面选中的图片
@property (nonatomic, copy) NSArray *assetsDataArray;

// 系统返回相册
@property (nonatomic, retain) PHFetchResult *originFetchResult;

///// 选择的Asset
@property (nonatomic, retain) NSMutableArray *selectedAssetsArray;

/// 选择 block
@property (nonatomic, copy) clickSelectBlock clickSelectBlock;
/// 完成 block
@property (nonatomic, copy) clickFinishBlock clickFinishBlock;
/// check block
@property (nonatomic, copy) clickCheckBlock clickCheckBlock;

/// 如果图片是gif，是否显示gif标
@property (nonatomic,assign) BOOL showGif;

@end

//
//  GLFetchImageGroup.h
//  GLUIKit
//
//  Created by xiaofengzheng on 3/14/16.
//  Copyright © 2016 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface GLFetchImageGroup : NSObject

/// 组名称
@property (nonatomic, copy) NSString *name;
/// 分组列表 展示title（组名+count）
@property (nonatomic, copy) NSString *title;
/// 组数据 ALAssetsGroup/PHFetchResult
@property (nonatomic, strong) id data;

@property (nonatomic, assign) BOOL isFirst;


/**
 *  用ALAssetsGroup实例一个对象
 *
 *  @param assetsGroup 数据单元
 *  @param hasVideoFlag     是否包含视频
 *
 *  @return 对象
 */
+ (GLFetchImageGroup *)getFetchImageGroupWithAssetsGroup:(ALAssetsGroup *)assetsGroup hasVideo:(BOOL)hasVideoFlag;



/**
 *  用PHAssetCollection实例一个对象
 *
 *  @param assetCollection 数据单元
 *  @param hasVideoFlag    是否包含视频
 *
 *  @return can be nil
 */
+ (GLFetchImageGroup *)getFetchImageGroupWithAssetCollection:(PHAssetCollection *)assetCollection hasVideo:(BOOL)hasVideoFlag;


+ (GLFetchImageGroup *)getFetchImageGroupWithFetchResult:(PHFetchResult * )fetchResult name:(NSString *)name isCameraRollAlbum:(BOOL)isCameraRollAlbum;

- (void)updateWithFetchImageGroup:(GLFetchImageGroup *)srcGroup;

@end

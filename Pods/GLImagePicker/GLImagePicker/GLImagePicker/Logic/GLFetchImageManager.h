//
//  GLFetchImageManager.h
//  GLUIKit
//
//  Created by xiaofengzheng on 3/13/16.
//  Copyright © 2016 koudai. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLFetchImageGroup.h"
#import "GLFetchImageAsset.h"



/// 将要显示的时候 会发送此 通知 object 为 GLSelectView 实例
extern NSString *const KFetchPreviewImageSuccessNotification;



typedef NS_ENUM(NSInteger, GLFetchImageAuthorizationStatus) {
    GLFetchImageAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
    GLFetchImageAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
    // The user cannot change this application’s status, possibly due to active restrictions
    //   such as parental controls being in place.
    GLFetchImageAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
    GLFetchImageAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
} ;

typedef NS_ENUM(NSInteger, GLFetchImageType) {
    GLFetchImageTypeALL = 0,   // 所有
    GLFetchImageTypeRecents,   // 最近联系
    GLFetchImageTypeExceptRecents   // 最近联系以外
} ;


@interface GLFetchImageManager : NSObject

/**
 *  选图 实例
 *
 *  @return 实例
 */
+ (GLFetchImageManager *)sharedInstance;

/**
 *  获取照片的访问权限
 *
 *  @return GLFetchImageAuthorizationStatus
 */
+ (GLFetchImageAuthorizationStatus)authorizationStatus;



+ (void)requestAuthorization:(void(^)(GLFetchImageAuthorizationStatus status))handler;

/**
 *  获取照片的分组
 *
 *  @param hasVideoFlag 是否包含视频
 *  @param completion   完成block
 */
- (void)fetchImageGroupHasVideo:(BOOL)hasVideoFlag
                     completion:(void (^) (NSArray<GLFetchImageGroup *> *groupArray, BOOL complete))completion;



- (void)fetchImageGroupHasVideo:(BOOL)hasVideoFlag withFetchType:(GLFetchImageType)fetchType completion:(void (^)(NSArray<GLFetchImageGroup *> *groupArray, BOOL complete))completion;
/**
 *  获取 分组下的照片
 *
 *  @param hasVideoFlag 是否包含视频 暂时无用
 *  @param group 分组
 *  @param completion 回调
 */
- (void)fetchImageAssetArrayHasVideo:(BOOL)hasVideoFlag
                               group:(GLFetchImageGroup *)group
                          completion:(void (^) (NSArray <GLFetchImageAsset *> *imageAssetArray))completion;

/**
 *  选出 分组 PostImage
 *
 *  @param group      分组
 *  @param completion 回到
 */
- (void)fetchPostImageWithGroup:(GLFetchImageGroup *)group
                     targetSize:(CGSize)targetSize
                     completion:(void (^)(UIImage *postImage))completion;
/**
 *  选出 图片
 *
 */
- (void)fetchImageWithAsset:(GLFetchImageAsset *)fetchImageAsset
                 targetSize:(CGSize)targetSize
                 completion:(void (^)(UIImage *image))completion progress:(void (^)(double progress))currentProgress;

/**
 *  选出 预览的图
 *
 */
- (void)fetchPreviewImageWithAsset:(GLFetchImageAsset *)fetchImageAsset
                        completion:(void (^)(UIImage *previewImage))completion progress:(void (^)(double progress))currentProgress;

- (void)fetchPreviewImageWithAsset:(GLFetchImageAsset *)fetchImageAsset
                          fetchGif:(BOOL)fetchGif
                        completion:(void (^)(UIImage *))completion progress:(void (^)(double))currentProgress;


/**
 *  检查图片 是否在本地
 *
 */
- (BOOL)checkImageIsInLocalAblumWithAsset:(GLFetchImageAsset *)fetchImageAsset;
- (BOOL)checkImageIsInLocalAblumWithAsset:(GLFetchImageAsset *)fetchImageAsset shouldShowGif:(BOOL)showGif;

@end

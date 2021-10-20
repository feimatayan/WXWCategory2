//
//  GLFetchImageManager.m
//  GLUIKit
//
//  Created by xiaofengzheng on 3/13/16.
//  Copyright © 2016 koudai. All rights reserved.
//

#import "GLFetchImageManager.h"

#import <GLUIKit/GLUIKit.h>
#import <Photos/Photos.h>

#import "ALAssetsLibrary+GLAssetsLibrary.h"
#import "GLFetchImageAsset.h"
#import "GLCommonDef.h"
#import "GLGifImageUtil.h"

#import "GLIPUTUtil.h"

NSString *const KFetchPreviewImageSuccessNotification  = @"FetchPreviewImageSuccessNotification";


@interface GLFetchImageManager ()

@end

@implementation GLFetchImageManager

+ (GLFetchImageManager *)sharedInstance
{
    static GLFetchImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)requestAuthorization:(void (^)(GLFetchImageAuthorizationStatus))handler
{
    if (GL_SYSTEM_IOS8) {
        // iOS 8.0 之后
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            GLFetchImageAuthorizationStatus ret = GLFetchImageAuthorizationStatusNotDetermined;
            if (status == PHAuthorizationStatusNotDetermined) {
                ret =  GLFetchImageAuthorizationStatusNotDetermined;
            } else if (status == PHAuthorizationStatusRestricted) {
                ret = GLFetchImageAuthorizationStatusRestricted;
            } else if (status == PHAuthorizationStatusDenied) {
                ret = GLFetchImageAuthorizationStatusDenied;
            } else if (status == PHAuthorizationStatusAuthorized){
                ret = GLFetchImageAuthorizationStatusAuthorized;
            }
            if (handler) {
                // 此处为异步线程返回
                if (![NSThread currentThread].isMainThread) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(ret);
                    });
                    
                } else {
                    handler(ret);
                }
            }
        }];
        
    } else {
        
        NSInteger status = [ALAssetsLibrary authorizationStatus];
        GLFetchImageAuthorizationStatus ret = GLFetchImageAuthorizationStatusNotDetermined;
        
        if (status == ALAuthorizationStatusNotDetermined) {
            ret = GLFetchImageAuthorizationStatusNotDetermined;
        } else if (status == ALAuthorizationStatusRestricted) {
            ret = GLFetchImageAuthorizationStatusRestricted;
        } else if (status == ALAuthorizationStatusDenied) {
            ret = GLFetchImageAuthorizationStatusDenied;
        } else if (status == ALAuthorizationStatusAuthorized){
            ret = GLFetchImageAuthorizationStatusAuthorized;
        }
        
        if (handler) {
            handler(ret);
        }
    }
}
+ (GLFetchImageAuthorizationStatus)authorizationStatus

{
    if (GL_SYSTEM_IOS8) {
        // iOS 8.0 之后
        NSInteger status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            return GLFetchImageAuthorizationStatusNotDetermined;
        } else if (status == PHAuthorizationStatusRestricted) {
            return GLFetchImageAuthorizationStatusRestricted;
        } else if (status == PHAuthorizationStatusDenied) {
            return GLFetchImageAuthorizationStatusDenied;
        } else if (status == PHAuthorizationStatusAuthorized){
            return GLFetchImageAuthorizationStatusAuthorized;
        }
        
        return GLFetchImageAuthorizationStatusAuthorized;
        
    } else {
        
        NSInteger status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusNotDetermined) {
            return GLFetchImageAuthorizationStatusNotDetermined;
        } else if (status == ALAuthorizationStatusRestricted) {
            return GLFetchImageAuthorizationStatusRestricted;
        } else if (status == ALAuthorizationStatusDenied) {
            return GLFetchImageAuthorizationStatusDenied;
        } else if (status == ALAuthorizationStatusAuthorized){
            return GLFetchImageAuthorizationStatusAuthorized;
        }
        
        return GLFetchImageAuthorizationStatusAuthorized;
    }
}

- (BOOL)isFirstGroup:(GLFetchImageGroup *)group
{
    
    BOOL flag = NO;
    if (group) {
        if ([group.data isKindOfClass:[PHFetchResult class]]) {
            flag = group.isFirst;
        } else {
            if ([group.name isEqualToString:@"所有照片"] || [group.name isEqualToString:@"All Photos"] ||
                [group.name isEqualToString:@"相机胶卷"] || [group.name isEqualToString:@"Camera Roll"]) {
                // sort 1
                flag = YES;
            }
        }
    }
    return flag;
}


//- (void)fetchImageGroupHasVideo:(BOOL)hasVideoFlag completion:(void (^)(NSArray<GLFetchImageGroup *> *))completion
//{
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    if (GL_SYSTEM_IOS8) {
//
//        // 相机的相册
//        PHFetchResult *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
//                                                                             subtype:PHAssetCollectionSubtypeAny
//                                                                             options:nil];
//
//        for (PHAssetCollection *collection in smartAlbum) {
//            GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithAssetCollection:collection hasVideo:hasVideoFlag];
//            if (group) {
//                //
//                if ([self isFirstGroup:group]) {
//                    [resultArray insertObject:group atIndex:0];
//                } else {
//                    [resultArray addObject:group];
//                }
//            }
//        }
//
//        // 衍生的相册
//        PHFetchResult *streamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
//                                                                              subtype:PHAssetCollectionSubtypeAny
//                                                                              options:nil];
//        for (PHAssetCollection *collection in streamAlbum) {
//            GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithAssetCollection:collection hasVideo:hasVideoFlag];
//            if (group) {
//                if ([group.name isEqualToString:@"我的照片流"] || [group.name isEqualToString:@"My Photo Stream"]) {
//                    GLFetchImageGroup *firstGroup = [resultArray firstObject];
//                    if ([self isFirstGroup:firstGroup]) {
//                        // sort 2
//                        [resultArray insertObject:group atIndex:1];
//                    } else {
//                        [resultArray insertObject:group atIndex:0];
//                    }
//                } else {
//                    [resultArray addObject:group];
//                }
//            }
//        }
//
//        if (completion) {
//            completion(resultArray);
//        }
//
//    } else {
//
//        ALAssetsFilter *filter = [ALAssetsFilter allAssets];
//        [[ALAssetsLibrary defaultAssetsLibrary] gl_assetsGroupsWithTypes:ALAssetsGroupAll
//                                                            assetsFilter:filter
//                                                              completion:^(NSArray<ALAssetsGroup *> *groupArray) {
//
//                                                                  for (ALAssetsGroup *group in groupArray) {
//                                                                      GLFetchImageGroup *fetchImageGroup = [GLFetchImageGroup getFetchImageGroupWithAssetsGroup:group hasVideo:hasVideoFlag];
//                                                                      [resultArray addObject:fetchImageGroup];
//                                                                  }
//                                                                  if (completion) {
//                                                                      completion(resultArray);
//                                                                  }
//
//
//        } failure:^(NSError *error) {
//
//            if (completion) {
//                completion(resultArray);
//            }
//        }];
//    }
//}


- (void)fetchImageGroupHasVideo:(BOOL)hasVideoFlag
                     completion:(void (^) (NSArray<GLFetchImageGroup *> *groupArray, BOOL complete))completion
{
    [self fetchImageGroupHasVideo:hasVideoFlag withFetchType:GLFetchImageTypeALL completion:completion];
}

- (void)fetchImageGroupHasVideo:(BOOL)hasVideoFlag withFetchType:(GLFetchImageType)fetchType completion:(void (^)(NSArray<GLFetchImageGroup *> *groupArray, BOOL complete))completion
{
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [GLIPUTUtil commitTechEvent:@"GLFetchImageManager"
                           arg1:@"fetchImageGroupHasVideo"
                           arg2:@"enter"
                           arg3:@""
                           args:@{@"module":@"GLImagePicker", @"startTime":@(startTime)}];

//    NSLog(@"***************** starttime:%0.1f",startTime);
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!hasVideoFlag) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (hasVideoFlag) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                PHAssetMediaTypeVideo];
    // option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:self.sortAscendingByModificationDate]];
//    if (!self.sortAscendingByModificationDate) {
//        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    }

    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];

    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];

    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];

    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];

    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
//    int i=0;
    for (PHFetchResult *fetchResult in allAlbums) {
//        NSTimeInterval albumstartTime = [[NSDate date] timeIntervalSince1970];
//        NSLog(@"***************** albums starttime:%0.1f",albumstartTime);
        for (PHAssetCollection *collection in fetchResult) {
//            NSTimeInterval colstartTime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection starttime:%0.1f",colstartTime);

//            NSLog(@"*********** i = %d", i);
//            i++;

//            NSLog(@"collection %@", collection.localizedTitle);
            
            NSString *title = collection.localizedTitle;
            
            [GLIPUTUtil commitTechEvent:@"GLFetchImageManager"
                                   arg1:@"fetchImageGroupHasVideo"
                                   arg2:@"check"
                                   arg3:@""
                                   args:@{@"module":@"GLImagePicker", @"collectiontitle":title}];
            switch (fetchType) {
                case GLFetchImageTypeALL:
                    
                    break;
                case GLFetchImageTypeRecents:
//                    if ([title isEqualToString:@"最近项目"] || [title isEqualToString:@"最近添加"]  || [title isEqualToString:@"Recents"] || [title isEqualToString:@"Recently Added"]) {
                    if ([title isEqualToString:@"最近项目"] || [title isEqualToString:@"最近添加"]  || [title isEqualToString:@"Recents"] || [title isEqualToString:@"Recently Added"] || [title isEqualToString:@"Camera Roll"] || [title isEqualToString:@"相机胶卷"] ) {
                        
                    } else {
                        continue;
                    }
                    break;
                case GLFetchImageTypeExceptRecents:
                    if ([title isEqualToString:@"最近项目"] || [title isEqualToString:@"最近添加"]  || [title isEqualToString:@"Recents"] || [title isEqualToString:@"Recently Added"] || [title isEqualToString:@"Camera Roll"] || [title isEqualToString:@"相机胶卷"] ) {
                        continue;
                    }
                    break;
                default:
                    break;
            }
//            if ([title isEqualToString:@"最近项目"] || [title isEqualToString:@"Recents"]) {
//
//            } else {
//                continue;
//            }
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            // 过滤空相册
            if (collection.estimatedAssetCount <= 0 && ![self isCameraRollAlbum:collection]) continue;

            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            NSTimeInterval temptime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection time 1:%0.1f",temptime);
            if (fetchResult.count < 1 && ![self isCameraRollAlbum:collection]) continue;

            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;
            if (collection.assetCollectionSubtype == 1000000201) continue; //『最近删除』相册
            temptime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection time 2:%0.1f",temptime);
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            if ([self isCameraRollAlbum:collection]) {
//                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES needFetchAssets:needFetchAssets] atIndex:0];

                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithFetchResult:fetchResult name:collection.localizedTitle isCameraRollAlbum:YES];

//                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithAssetCollection:collection hasVideo:hasVideoFlag];

                if (group) {
                    //
                    if ([self isFirstGroup:group]) {
                        [resultArray insertObject:group atIndex:0];
                    } else {
                        [resultArray addObject:group];
                    }
                }

            } else {
//                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:NO needFetchAssets:needFetchAssets]];

                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithFetchResult:fetchResult name:collection.localizedTitle isCameraRollAlbum:NO];

//                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithAssetCollection:collection hasVideo:hasVideoFlag];
                if (group) {
                    [resultArray addObject:group];
                }
            }
            
            completion(resultArray, NO);
//            temptime = [[NSDate date] timeIntervalSince1970];
////            NSLog(@"***************** collection time 3:%0.1f",temptime);
//
//            NSTimeInterval colendTime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection end time:%0.1f",colendTime);
//            NSLog(@"***************** collection cost time:%0.001f",(colendTime - colstartTime));
        }
//        NSTimeInterval albumendTime  = [[NSDate date] timeIntervalSince1970];
//        NSLog(@"***************** albums endtime:%0.1f",albumendTime);
//        NSLog(@"***************** albums cost time:%0.001f",(albumendTime - albumendTime));
    }
    if (completion) {
        completion(nil, YES);
    }

    startTime = [[NSDate date] timeIntervalSince1970];
    [GLIPUTUtil commitTechEvent:@"GLFetchImageManager"
                           arg1:@"fetchImageGroupHasVideo"
                           arg2:@"end"
                           arg3:@""
                           args:@{@"module":@"GLImagePicker", @"endTime":@(startTime)}];
}


//- (void)fetchImageGroupHasVideo:(BOOL)hasVideoFlag completion:(void (^)(NSArray<GLFetchImageGroup *> *))completion
//{
//    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
//    [GLIPUTUtil commitTechEvent:@"GLFetchImageManager"
//                           arg1:@"fetchImageGroupHasVideo"
//                           arg2:@"enter"
//                           arg3:@""
//                           args:@{@"module":@"GLImagePicker", @"startTime":@(startTime)}];
//
//    NSLog(@"***************** starttime:%0.1f",startTime);
//    PHFetchOptions *option = [[PHFetchOptions alloc] init];
//    if (!hasVideoFlag) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
//    if (hasVideoFlag) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
//                                                PHAssetMediaTypeVideo];
//    // option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:self.sortAscendingByModificationDate]];
////    if (!self.sortAscendingByModificationDate) {
////        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
////    }
//
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//
//    PHFetchResult *recentlyAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//
//    NSArray *allAlbums = @[recentlyAlbums];
//    int i=0;
//    for (PHFetchResult *fetchResult in allAlbums) {
//        NSTimeInterval albumstartTime = [[NSDate date] timeIntervalSince1970];
//        NSLog(@"***************** albums starttime:%0.1f",albumstartTime);
//        for (PHAssetCollection *collection in fetchResult) {
//            NSTimeInterval colstartTime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection starttime:%0.1f",colstartTime);
//
//            NSLog(@"*********** i = %d", i);
//            i++;
//
//            NSLog(@"collection %@", collection.localizedTitle);
//            // 有可能是PHCollectionList类的的对象，过滤掉
//            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
//            // 过滤空相册
//            if (collection.estimatedAssetCount <= 0 && ![self isCameraRollAlbum:collection]) continue;
//
////            NSString *title = collection.localizedTitle;
//
//            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
//            NSTimeInterval temptime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection time 1:%0.1f",temptime);
//            if (fetchResult.count < 1 && ![self isCameraRollAlbum:collection]) continue;
//
//            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;
//            if (collection.assetCollectionSubtype == 1000000201) continue; //『最近删除』相册
//            temptime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection time 2:%0.1f",temptime);
//            if ([self isCameraRollAlbum:collection]) {
////                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES needFetchAssets:needFetchAssets] atIndex:0];
//
//                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithFetchResult:fetchResult name:collection.localizedTitle isCameraRollAlbum:YES];
//
////                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithAssetCollection:collection hasVideo:hasVideoFlag];
//
//                if (group) {
//                    //
//                    if ([self isFirstGroup:group]) {
//                        [resultArray insertObject:group atIndex:0];
//                    } else {
//                        [resultArray addObject:group];
//                    }
//                }
//
//            } else {
////                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:NO needFetchAssets:needFetchAssets]];
//
//                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithFetchResult:fetchResult name:collection.localizedTitle isCameraRollAlbum:NO];
//
////                GLFetchImageGroup *group = [GLFetchImageGroup getFetchImageGroupWithAssetCollection:collection hasVideo:hasVideoFlag];
//                if (group) {
//                    [resultArray addObject:group];
//                }
//            }
//            temptime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection time 3:%0.1f",temptime);
//
//            NSTimeInterval colendTime = [[NSDate date] timeIntervalSince1970];
//            NSLog(@"***************** collection end time:%0.1f",colendTime);
//            NSLog(@"***************** collection cost time:%0.001f",(colendTime - colstartTime));
//        }
//        NSTimeInterval albumendTime  = [[NSDate date] timeIntervalSince1970];
//        NSLog(@"***************** albums endtime:%0.1f",albumendTime);
//        NSLog(@"***************** albums cost time:%0.001f",(albumendTime - albumendTime));
//    }
//    if (completion) {
//        completion(resultArray);
//    }
//
//    startTime = [[NSDate date] timeIntervalSince1970];
//    [GLIPUTUtil commitTechEvent:@"GLFetchImageManager"
//                           arg1:@"fetchImageGroupHasVideo"
//                           arg2:@"end"
//                           arg3:@""
//                           args:@{@"module":@"GLImagePicker", @"endTime":@(startTime),@"resultArrayCount":@(resultArray.count)}];
//}
//
//
//
- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
}

/**
 *  获取 分组下的照片
 *
 *  @param hasVideoFlag 是否包含视频
 *  @param group
 *  @param completion
 */
- (void)fetchImageAssetArrayHasVideo:(BOOL)hasVideoFlag group:(GLFetchImageGroup *)group completion:(void (^) (NSArray <GLFetchImageAsset *> *imageAssetArray))completion
{
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    if ([group.data isKindOfClass:[PHFetchResult class]]) {
        
        PHFetchResult *fetchResult = group.data;
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [retArray addObject:[GLFetchImageAsset getFetchImageAsseWithPHAsset:obj]];
            }
        }];
        
        if (completion) {
            completion(retArray);
        }
    } else if ([group.data isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *assetsGroup = group.data;
        [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            //
            if (result) {
                [retArray addObject:[GLFetchImageAsset getFetchImageAsseWithALAsset:result]];
            } else {
                // if finished,result set to nil
                if (completion) {
                    completion(retArray);
                }
            }
        }];
    }
}

/**
 *  获取 分组照片的PostImage
 *
 *  @param group      分组
 *  @param completion
 */
- (void)fetchPostImageWithGroup:(GLFetchImageGroup *)group targetSize:(CGSize)targetSize completion:(void (^)(UIImage *))completion
{
    // image
    if ([group.data isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = group.data;
        if (fetchResult.count > 0) {
            [[PHImageManager defaultManager] requestImageForAsset:fetchResult.lastObject
                                                       targetSize:targetSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:nil
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        //
                                                        if (completion) {
                                                            completion(result);
                                                        }
                                                    }];
        } else {
            if (completion) {
                completion(nil);
            }
        }
    } else if ([group.data isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *assetsGroup = group.data;
        UIImage *postImage = [UIImage imageWithCGImage:assetsGroup.posterImage];
        if (completion) completion(postImage);
    }
}

//获取图片
- (void)fetchImageWithAsset:(GLFetchImageAsset *)fetchImageAsset targetSize:(CGSize)targetSize completion:(void (^)(UIImage *))completion progress:(void (^)(double))currentProgress
{
    [self fetchImageWithAsset:fetchImageAsset
                   targetSize:targetSize
                     fetchGif:NO
                   completion:completion
                     progress:currentProgress];
}

//获取带gif的图片
- (void)fetchImageWithAsset:(GLFetchImageAsset *)fetchImageAsset
                 targetSize:(CGSize)targetSize
                   fetchGif:(BOOL)fetchGif
                 completion:(void (^)(UIImage *))completion
                   progress:(void (^)(double))currentProgress
{
    if ([fetchImageAsset.data isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = fetchImageAsset.data;
        UIImage *image = [UIImage imageWithCGImage:alAsset.aspectRatioThumbnail];
        if (completion) {
            completion(image);
        }
    } else if ([fetchImageAsset.data isKindOfClass:[PHAsset class]]) {
        
        CGFloat scale = GLUIKIT_SCREEN_SCALE;
        CGSize fullScreenSize = CGSizeMake(GLUIKIT_SCREEN_WIDTH * scale, GLUIKIT_SCREEN_HEIGHT * scale);
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            
            if (progress < 0.01) {
                progress = 0.01;
            }
            fetchImageAsset.progress = progress;
            
            if (currentProgress) {
                currentProgress(progress);
            }
            
            if (CGSizeEqualToSize(targetSize, fullScreenSize)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:KFetchPreviewImageSuccessNotification object:nil];
                });
            }
        };
        
        if(fetchGif)
        {
            [self requestData:fetchImageAsset targetSize:targetSize options:options completion:completion];
        }
        else
        {
            [self requestImage:fetchImageAsset targetSize:targetSize options:options completion:completion];
        }
    }
}

- (void)requestImage:(GLFetchImageAsset *)fetchImageAsset
          targetSize:(CGSize)targetSize
             options:(PHImageRequestOptions*)options
          completion:(void (^)(UIImage *))completion
{
    CGFloat scale = GLUIKIT_SCREEN_SCALE;
    CGSize fullScreenSize = CGSizeMake(GLUIKIT_SCREEN_WIDTH * scale, GLUIKIT_SCREEN_HEIGHT * scale);

    [[PHImageManager defaultManager] requestImageForAsset:fetchImageAsset.data
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                
                                                if (completion) {
                                                    if (fetchImageAsset.imageEditing) {
                                                        completion(fetchImageAsset.imageEditing);
                                                    } else {
                                                        completion(result);
                                                    }
                                                }
                                                if (![[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue] && CGSizeEqualToSize(targetSize, fullScreenSize)) {
                                                    
                                                    fetchImageAsset.fullScreenImage = result;                                                        fetchImageAsset.progress = 1;
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:KFetchPreviewImageSuccessNotification object:nil];
                                                    });
                                                }
                                            }];
}

- (void)requestData:(GLFetchImageAsset *)fetchImageAsset
         targetSize:(CGSize)targetSize
             options:(PHImageRequestOptions*)options
          completion:(void (^)(UIImage *))completion
{
    CGFloat scale = GLUIKIT_SCREEN_SCALE;
    CGSize fullScreenSize = CGSizeMake(GLUIKIT_SCREEN_WIDTH * scale, GLUIKIT_SCREEN_HEIGHT * scale);

    [[PHImageManager defaultManager] requestImageDataForAsset:fetchImageAsset.data
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    
                                                    UIImage *img = nil;

                                                    if (fetchImageAsset.isGIF) {
                                                        img = [GLGifImageUtil animatedGIFWithData:imageData];
                                                        fetchImageAsset.gifData = imageData;
                                                    } else {
                                                        img = [UIImage imageWithData:imageData];
                                                    }
                                                    
                                                    if (completion) {
                                                        if (fetchImageAsset.imageEditing) {
                                                            completion(fetchImageAsset.imageEditing);
                                                        } else {
                                                            completion(img);
                                                        }
                                                    }
                                                    if (![[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue] && CGSizeEqualToSize(targetSize, fullScreenSize)) {
                                                        
                                                        fetchImageAsset.fullScreenImage = img;
                                                        fetchImageAsset.progress = 1;
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:KFetchPreviewImageSuccessNotification object:nil];
                                                        });
                                                    }
        
    }];
}

- (void)fetchPreviewImageWithAsset:(GLFetchImageAsset *)fetchImageAsset fetchGif:(BOOL)fetchGif completion:(void (^)(UIImage *))completion progress:(void (^)(double))currentProgress
{
    if ([fetchImageAsset.data isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = fetchImageAsset.data;
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[[alAsset defaultRepresentation] fullScreenImage]];
        if (fullScreenImage) {
            if (completion) {
                completion(fullScreenImage);
            }
        }
    } else if ([fetchImageAsset.data isKindOfClass:[PHAsset class]]) {
        
        CGFloat scale = GLUIKIT_SCREEN_SCALE;
        CGSize size = CGSizeMake(GLUIKIT_SCREEN_WIDTH * scale, GLUIKIT_SCREEN_HEIGHT * scale);
        [self fetchImageWithAsset:fetchImageAsset targetSize:size fetchGif:fetchGif completion:^(UIImage *image) {
            if (completion) {
                completion(image);
            }
        } progress:^(double progress) {
            if (currentProgress) {
                
                currentProgress(progress);
            }
        }];
    }
}

- (void)fetchPreviewImageWithAsset:(GLFetchImageAsset *)fetchImageAsset completion:(void (^)(UIImage *))completion progress:(void (^)(double))currentProgress
{
    [self fetchPreviewImageWithAsset:fetchImageAsset fetchGif:NO completion:completion progress:currentProgress];
}

- (BOOL)checkImageIsInLocalAblumWithAsset:(GLFetchImageAsset *)fetchImageAsset
{
    return [self checkImageIsInLocalAblumWithAsset:fetchImageAsset shouldShowGif:NO];
}

- (BOOL)checkImageIsInLocalAblumWithAsset:(GLFetchImageAsset *)fetchImageAsset shouldShowGif:(BOOL)showGif
{
    if ([fetchImageAsset.data isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = NO;
        option.synchronous = YES;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        __block BOOL isInLocalAblum = YES;
		
		CGFloat scale = GLUIKIT_SCREEN_SCALE;
		CGSize size = CGSizeMake(GLUIKIT_SCREEN_WIDTH * scale, GLUIKIT_SCREEN_HEIGHT * scale);
		
        if([fetchImageAsset isGIF] && showGif) {
            [[PHImageManager defaultManager] requestImageDataForAsset:fetchImageAsset.data
                                                              options:option
                                                        resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                            UIImage *img = [GLGifImageUtil animatedGIFWithData:imageData];
                                                            
                                                            if (imageData) {
                                                                isInLocalAblum = YES;
                                                                fetchImageAsset.progress = 1;
                                                                fetchImageAsset.fullScreenImage = img;
                                                                fetchImageAsset.gifData = imageData;
                                                            } else {
                                                                isInLocalAblum = NO;
                                                            }
                                                    }];
        } else {
            [[PHImageManager defaultManager] requestImageForAsset:fetchImageAsset.data
                                                       targetSize:size
                                                      contentMode:PHImageContentModeAspectFit
                                                          options:option
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        
                                                        if (result) {
                                                            if (result.size.width < 1080) {
                                                                // fix:存在图片宽高比异常，例如 宽750*8000的图片原方法取出来为 280*3000，图片不清晰
                                                                // 添加判断，当选取出来的图片宽度<1080的时候，重新获取原图。
                                                                [[PHImageManager defaultManager] requestImageForAsset:fetchImageAsset.data targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable orgImage, NSDictionary * _Nullable info) {
                                                                    if (orgImage) {
                                                                        isInLocalAblum = YES;
                                                                        fetchImageAsset.progress = 1;
                                                                        fetchImageAsset.fullScreenImage = orgImage;
                                                                    } else {
                                                                        isInLocalAblum = YES;
                                                                        fetchImageAsset.progress = 1;
                                                                        fetchImageAsset.fullScreenImage = result;
                                                                    }
                                                                }];
                                                            }
                                                            else {
                                                                isInLocalAblum = YES;
                                                                fetchImageAsset.progress = 1;
                                                                fetchImageAsset.fullScreenImage = result;
                                                            }
                                                            
                                                        } else {
                                                            isInLocalAblum = NO;
                                                        }
                                                    }];
        }
            
        return isInLocalAblum;
        
    } else if ([fetchImageAsset.data isKindOfClass:[ALAsset class]]) {
        return YES;
    }
    
    return YES;
}

@end

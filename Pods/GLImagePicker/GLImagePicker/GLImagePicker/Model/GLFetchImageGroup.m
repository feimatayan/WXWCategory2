//
//  GLFetchImageGroup.m
//  GLUIKit
//
//  Created by xiaofengzheng on 3/14/16.
//  Copyright © 2016 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLFetchImageGroup.h"
#import <GLUIKit/GLUIKit.h>



@implementation GLFetchImageGroup



+ (GLFetchImageGroup *)getFetchImageGroupWithAssetsGroup:(ALAssetsGroup *)assetsGroup hasVideo:(BOOL)hasVideoFlag
{
    GLFetchImageGroup *fetchImageGroup = [[GLFetchImageGroup alloc] init];
    if (!hasVideoFlag) {
        [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    }
    
    NSString *name = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [assetsGroup numberOfAssets];
    fetchImageGroup.title = [NSString stringWithFormat:@"%@ (%zd)",name,count];
    fetchImageGroup.data = assetsGroup;
    fetchImageGroup.name = name;
    return fetchImageGroup;
}






+ (GLFetchImageGroup *)getFetchImageGroupWithAssetCollection:(PHAssetCollection *)assetCollection hasVideo:(BOOL)hasVideoFlag
{
    // 此处v7.1.0 热修复代码
    if (!assetCollection || ![assetCollection isKindOfClass:[PHAssetCollection class]]) {
        return nil;
    }
    
    GLFetchImageGroup *fetchImageGroup = [[GLFetchImageGroup alloc] init];
 
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    // 默认排序 Passing "nil" for options gets the default
//    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
    if (!hasVideoFlag) {
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    }
//    if (@available(iOS 9, *)) {
//        fetchOptions.fetchLimit = 1;
//    } else {
//        // Fallback on earlier versions
//    }
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    if (fetchResult.count > 0) {
        if (assetCollection.assetCollectionType == PHAssetCollectionTypeSmartAlbum
            && assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            fetchImageGroup.isFirst = YES;
        } else {
            fetchImageGroup.isFirst = NO;
        }
        NSString *name = assetCollection.localizedTitle;
        NSInteger count = [fetchResult count];
        fetchImageGroup.title = [NSString stringWithFormat:@"%@ (%zd)",name,count];
        fetchImageGroup.data = fetchResult;
        fetchImageGroup.name = name;
        return fetchImageGroup;
    } else {
        return nil;
    }
}


+ (GLFetchImageGroup *)getFetchImageGroupWithFetchResult:(PHFetchResult * )fetchResult name:(NSString *)name isCameraRollAlbum:(BOOL)isCameraRollAlbum {
    if (fetchResult.count > 0) {
        
        GLFetchImageGroup *fetchImageGroup = [[GLFetchImageGroup alloc] init];
        
        if (isCameraRollAlbum) {
            fetchImageGroup.isFirst = YES;
        } else {
            fetchImageGroup.isFirst = NO;
        }
        
        NSInteger count = [fetchResult count];
        fetchImageGroup.title = [NSString stringWithFormat:@"%@ (%zd)",name,count];
        fetchImageGroup.data = fetchResult;
        fetchImageGroup.name = name;
        return fetchImageGroup;
    } else {
        return nil;
    }
    
}


- (void)updateWithFetchImageGroup:(GLFetchImageGroup *)srcGroup {
    self.name = srcGroup.name;
    self.title = srcGroup.title;
    self.data = srcGroup.data;
    self.isFirst = self.isFirst;
}

@end

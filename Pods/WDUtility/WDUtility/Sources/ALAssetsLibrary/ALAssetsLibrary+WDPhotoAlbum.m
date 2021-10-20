//
//  ALAssetsLibrary+WDPhotoAlbum.m
//  WDUtility
//
//  Created by yuping on 17/2/16.
//  Copyright (c) 2017年 yuping. All rights reserved.
//

#import "ALAssetsLibrary+WDPhotoAlbum.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/Photos.h>

#define isIOS8  ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

@implementation ALAssetsLibrary(WDPhotoAlbum)

-(void)wd_saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    if (isIOS8) {
        if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self addAssets:image toAlbum:albumName withCompletionBlock:completionBlock];
            }];
        }
        else {
            [self addAssets:image toAlbum:albumName withCompletionBlock:completionBlock];
        }
    }
    else {
        [self writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                           completionBlock:^(NSURL* assetURL, NSError* error) {
                               
                               //error handling
                               if (error!=nil) {
                                   completionBlock(error);
                                   return;
                               }
                               
                               //add the asset to the custom photo album
                               [self wd_addAssetURL:assetURL
                                         toAlbum:albumName
                             withCompletionBlock:completionBlock];
                               
                           }];
    }
}

-(void)wd_addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    __block BOOL albumWasFound = NO;
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                albumWasFound = YES;
                                [self assetForURL: assetURL
                                      resultBlock:^(ALAsset *asset) {
                                          [group addAsset: asset];
                                          completionBlock(nil);
                                      } failureBlock: completionBlock];
                                return;
                            }
                            
                            if (group==nil && albumWasFound==NO)
                            {
                                /*
                                  iOS8以上，新增Recently Delete功能，导致“手动删除创建的相册，再次添加仍不会出现”
                                  iOS8以上，使用Photos.framework代替AssetsLibrary.framework，可解决这个问题
                                 */
                                if (isIOS8) {
                                    __weak ALAssetsLibrary* weakSelf = self;
                                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
                                    } completionHandler:^(BOOL success, NSError *error) {
                                        if (success) {
                                            [weakSelf enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                                    [weakSelf assetForURL: assetURL
                                                              resultBlock:^(ALAsset *asset) {
                                                                  
                                                                  //add photo to the target album
                                                                  [group addAsset: asset];
                                                                  
                                                                  //run the completion block
                                                                  [self performSelectorOnMainThread:@selector(saveCompletionSuccess:) withObject:completionBlock waitUntilDone:YES];
//                                                                  completionBlock(nil);
                                                              } failureBlock: completionBlock];
                                                }
                                            } failureBlock:completionBlock];
                                        }
                                    }];
                                }else{
                                    __weak ALAssetsLibrary* weakSelf = self;
                                    [self addAssetsGroupAlbumWithName:albumName
                                                          resultBlock:^(ALAssetsGroup *group) {
                                                              [weakSelf assetForURL: assetURL
                                                                        resultBlock:^(ALAsset *asset) {
                                                                            [group addAsset: asset];
                                                                            [weakSelf performSelectorOnMainThread:@selector(saveCompletionSuccess:) withObject:completionBlock waitUntilDone:YES];
                                                                        } failureBlock: completionBlock];
                                                              
                                                          } failureBlock: completionBlock];
                                    return;
                                }
                            }
                            
                            
                        } failureBlock: completionBlock];
    
}

- (void)addAssets:(UIImage *)image toAlbum:(NSString *)albumName withCompletionBlock:(SaveImageCompletion)completionBlock {
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    __block PHAssetCollection *collection;
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([result.localizedTitle isEqualToString:albumName]) {
            collection = result;
            *stop = YES;
        }
    }];
    if (!collection) {
        NSError *error;
        __block NSString *localIdentifier;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest *createCollection = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            localIdentifier = createCollection.placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        if (error) {
            [self saveCompletion:completionBlock withError:error];
            return;
        }
        collection = [[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentifier?:@""] options:nil] firstObject];
    }
    [[PHPhotoLibrary  sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *createAsset = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHAssetCollectionChangeRequest *changeCollection = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        [changeCollection addAssets:@[createAsset.placeholderForCreatedAsset]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        [self saveCompletion:completionBlock withError:error];
    }];
}

- (void)saveCompletion:(SaveImageCompletion)completionBlock withError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(error);
    });
}

@end

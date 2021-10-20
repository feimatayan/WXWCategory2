//
//  ALAssetsLibrary+GLAssetsLibrary.m
//  WDCommlib
//
//  Created by xiaofengzheng on 12/17/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import "ALAssetsLibrary+GLAssetsLibrary.h"

@implementation ALAssetsLibrary (GLAssetsLibrary)


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}



- (void)gl_assetsGroupsWithTypes:(ALAssetsGroupType)types
                    assetsFilter:(ALAssetsFilter *)filter
                      completion:(void (^)(NSArray<ALAssetsGroup *> *))completion
                         failure:(void (^)(NSError *))failure

{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self
     enumerateGroupsWithTypes:types
     usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
         if (group) {
             [group setAssetsFilter:filter];
             // 展示 分组为0的
             if ([group numberOfAssets] > 0) {
                 NSNumber *type = [group valueForProperty:ALAssetsGroupPropertyType];
                 NSMutableArray *groups = [dictionary objectForKey:type];
                 if (groups == nil) {
                     groups = [NSMutableArray arrayWithCapacity:1];
                     [dictionary setObject:groups forKey:type];
                 }
                 [groups addObject:group];
             }
         }
         else {
             
             // declare types
             static dispatch_once_t token;
             static NSArray *types = nil;
             dispatch_once(&token, ^{
                 types = @[
                           @(ALAssetsGroupSavedPhotos),
                           @(ALAssetsGroupPhotoStream),
                           @(ALAssetsGroupLibrary),
                           @(ALAssetsGroupAlbum),
                           @(ALAssetsGroupEvent),
                           @(ALAssetsGroupFaces)
                           ];
             });
            
             // sort known groups into final container
             NSMutableArray *array = [NSMutableArray array];
             for (NSNumber *typeNumber in types) {
                 NSMutableArray *groups = [dictionary objectForKey:typeNumber];
                 ALAssetsGroupType type = [typeNumber unsignedIntegerValue];
                 if (type != ALAssetsGroupEvent) {
                     // 同类型 排序
                     [groups sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         NSString *name1 = [obj1 valueForProperty:ALAssetsGroupPropertyName];
                         NSString *name2 = [obj2 valueForProperty:ALAssetsGroupPropertyName];
                         return [name1 localizedCompare:name2];
                     }];
                 }
                 [array addObjectsFromArray:groups];
                 [dictionary removeObjectForKey:typeNumber];
             }
             
             // call completion
             if (completion) {
                 dispatch_async(dispatch_get_main_queue(), ^{ completion([array copy]); });
             }
             
         }
     }
     failureBlock:^(NSError *error) {
         if (failure) {
             dispatch_async(dispatch_get_main_queue(), ^{ failure(error); });
         }
     }];
}




/**
 *  Get assets belonging to a certain group with the newest asset appearing first.
 *
 *  @param URL        The URL that identifies the desired group.
 *  @param filter     Filter the types of assets returned.
 *  @param completion Called on the main thread with an array of assets and a reference to the selected group.
 *  @param failure    Called on the main thread with an error.
 */
- (void)gl_assetsInGroupGroupWithURL:(NSURL *)URL
                        assetsFilter:(ALAssetsFilter *)filter
                          completion:(void (^) (ALAssetsGroup *group, NSArray *assets))completion
                             failure:(void (^) (NSError *error))failure {
    [self
     groupForURL:URL
     resultBlock:^(ALAssetsGroup *group) {
         NSMutableArray *assets = nil;
         if (group) {
             [group setAssetsFilter:filter];
             assets = [NSMutableArray arrayWithCapacity:[group numberOfAssets]];
             [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                 if (result) { [assets addObject:result]; }
             }];
         }
         if (completion) {
             dispatch_async(dispatch_get_main_queue(), ^{ completion(group, assets); });
         }
     }
     failureBlock:^(NSError *error) {
         if (failure) {
             dispatch_async(dispatch_get_main_queue(), ^{ failure(error); });
         }
     }];
}


@end

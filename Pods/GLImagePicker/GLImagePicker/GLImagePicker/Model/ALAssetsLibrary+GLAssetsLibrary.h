//
//  ALAssetsLibrary+GLAssetsLibrary.h
//  WDCommlib
//
//  Created by xiaofengzheng on 12/17/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (GLAssetsLibrary)






/**
 *  ALAssetsLibrary 实例化
 *
 *  @return 实例对象
 */
+ (ALAssetsLibrary *)defaultAssetsLibrary;










/**
 *  Get groups sorted the same as seen in UIImagePickerController
 *
 *  @param types      Filter group types. Pass ALAssetGroupAll for all groups.
 *  @param filter     Filter asset types. Groups with no assets matching the filter will be omitted.
 *  @param completion Called on the main thread with an array of groups.
 *  @param failure    Called on the main thread with an error.
 */
- (void)gl_assetsGroupsWithTypes:(ALAssetsGroupType)types
                    assetsFilter:(ALAssetsFilter *)filter
                      completion:(void (^) (NSArray <ALAssetsGroup *> *groupArray))completion
                         failure:(void (^) (NSError *error))failure;










@end

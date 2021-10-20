//
//  GLAssetsCell.h
//  WDCommlib
//
//  Created by xiaofengzheng on 12/17/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#import <GLUIKit/GLUIKit.h>
#import "GLFetchImageAsset.h"

extern CGFloat kELCAssetCellHeight;
extern CGFloat kELCAssertOffset;
extern NSInteger kELCAssetCellColoumns;

typedef void(^clickAssetBlock)(GLFetchImageAsset *asset);
typedef BOOL(^clickCheckBlock)(GLFetchImageAsset *);

@class GLFetchImageAsset;

@interface GLAssetsListCell : GLTableViewCell


- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;

- (void)setAssets:(NSArray *)assets;

/// 点击回调
@property (nonatomic, copy) clickAssetBlock clickAssetBlock;
/// 校验回到 before clickAssetBlock
@property (nonatomic, copy) clickCheckBlock clickCheckBlock;

/// 如果图片是gif，是否显示gif标
@property (nonatomic,assign) BOOL showGif;

@end

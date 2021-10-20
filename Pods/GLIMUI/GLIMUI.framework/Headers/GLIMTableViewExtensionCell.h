//
//  GLIMTableViewExtensionCell.h
//  GLIMUI
//
//  Created by huangbiao on 2018/12/25.
//  Copyright © 2018 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 空协议，方便子类进行扩展
 */
@protocol GLIMTableViewExtensionCellDelegate <NSObject>

@end

@interface GLIMTableViewExtensionCell : UITableViewCell

/**
 计算扩展功能Cell
 
 @param cellData cell数据
 @return cell高度
 */
+ (CGFloat)cellHeightWithCellData:(id)cellData;

+ (CGFloat)cellWWithCellData:(id)cellData;

@property (nonatomic, strong) id cellData;

@property (nonatomic, weak) id<GLIMTableViewExtensionCellDelegate> cellDelegate;

#pragma mark - 统计
/// 用于记录ut统计的页面
@property (nonatomic, copy) NSString *utPageName;

- (void)sendExposurelogEvent;



@end



@interface GLIMCollectionViewExtensionCell : UICollectionViewCell

/**
 计算扩展功能Cell
 
 @param cellData cell数据
 @return cell高度
 */
+ (CGFloat)cellHeightWithCellData:(id)cellData;

+ (CGFloat)cellWWithCellData:(id)cellData;

@property (nonatomic, strong) id cellData;

/// 记录cell所在的父视图
@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, weak) id<GLIMTableViewExtensionCellDelegate> cellDelegate;

#pragma mark - 统计
/// 用于记录ut统计的页面
@property (nonatomic, copy) NSString *utPageName;

- (void)sendExposurelogEvent;



@end


NS_ASSUME_NONNULL_END

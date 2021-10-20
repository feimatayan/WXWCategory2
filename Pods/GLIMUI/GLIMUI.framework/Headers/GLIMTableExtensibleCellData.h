//
//  GLIMTableExtensibleCellData.h
//  GLIMUI
//
//  Created by huangbiao on 2018/12/25.
//  Copyright © 2018 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GLIMTableViewExtensionCellDelegate;

@interface GLIMTableExtensibleCellData : NSObject <GLIMTableViewExtensionCellDelegate>

/// 显示数据
@property (nonatomic, strong) id cellData;
/// 显示Cell的类名
@property (nonatomic, copy) NSString *cellClassName;

/// 子账号是否禁止操作（显示但不能操作），默认为NO
@property (nonatomic, assign) BOOL disableSubAccountAction;

/// 处理点击事件
- (void)didExtensibleCellClicked:(GLIMBaseViewController *)viewController;




//左右
- (UIEdgeInsets)sectionInset;

//列数
- (NSInteger)columnCount;

//列间距
- (NSInteger)minimumInteritemSpacing;

//行间距
- (NSInteger)minimumLineSpacing;



@end

NS_ASSUME_NONNULL_END

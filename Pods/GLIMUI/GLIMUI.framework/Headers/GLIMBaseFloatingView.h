//
//  GLIMBaseFloatingView.h
//  GLIMUI
//
//  Created by huangbiao on 2021/8/27.
//  Copyright © 2021 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 悬浮视图协议
 如果是消息，key为@”message“，value为message实体
 其他待补充
 示例：@{@"message":message}
 **/
typedef void (^GLIMFloatingViewBlock)(NSDictionary *params);

/// 浮动视图
@interface GLIMBaseFloatingView : UIView

/// 持有父视图
@property (nonatomic, weak) UIView *parentView;

/// 回调处理
@property (nonatomic, strong) GLIMFloatingViewBlock block;

/// 标识是否全屏，默认为NO
@property (nonatomic, assign) BOOL isFullView;

/// 隐藏视图
- (void)hideView;

/// 显示在父视图中
/// @param parentView 父视图
/// @param block 回调函数
+ (instancetype)showViewInParentView:(UIView *)parentView withBlock:(GLIMFloatingViewBlock)block;

/// 全屏显示
/// @param block 回调函数
+ (instancetype)showFullViewWithBlock:(GLIMFloatingViewBlock)block;


/// 子类实现具体的UI
/// @param bottomOffset 底部安全偏移
- (UIView *)buildContentView:(CGFloat)bottomOffset;

@end

@interface GLIMFloatingViewHelper : NSObject

/// 全屏显示
/// @param block 回调函数
+ (GLIMBaseFloatingView *)showFullViewWithClassName:(NSString *)className block:(GLIMFloatingViewBlock)block;

+ (GLIMBaseFloatingView *)showViewInParentView:(UIView *)parentView className:(NSString *)className block:(GLIMFloatingViewBlock)block;

@end

NS_ASSUME_NONNULL_END

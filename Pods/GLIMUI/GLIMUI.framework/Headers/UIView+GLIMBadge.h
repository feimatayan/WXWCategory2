//
//  UIView+GLIMBadge.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/27.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GLIMBadgeType)
{
    GLIMBadgeNone,      // 无
    GLIMBadgeRedDot,    // 红点
    GLIMBadgeNew,       // new
    GLIMBadgeNumber,    // 数字
};

/**
 添加Badge视图
 */
@interface UIView (GLIMBadge)

@property (nonatomic, strong) UIImageView *badgeImageView;

/**
 显示badgeView
 暂不支持显示数字

 @param badgeType   badge类型，红点、new，
 @param badgeKey    badge的key值，用于持久化badgeView显隐藏信息
 */
- (void)glim_showBadgeWithType:(GLIMBadgeType)badgeType badgeKey:(NSString *)badgeKey;


/**
 隐藏badgeView

 @param badgeKey    badge的key值，用于持久化badgeView显隐藏信息
 */
- (void)glim_hideBadgeWithKey:(NSString *)badgeKey;

@end

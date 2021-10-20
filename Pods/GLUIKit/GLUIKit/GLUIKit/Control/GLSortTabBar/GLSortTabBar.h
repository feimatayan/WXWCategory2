//
//  GLSortTabBar.h
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 30/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLView.h"

typedef NS_ENUM(NSInteger, GLSortTabBarSortType) {
    GLSortTabBarSortTypeUp,                 // 升序
    GLSortTabBarSortTypeDown,               // 降序
    GLSortTabBarSortTypeNone                // 无
};


@protocol GLSortTabBarDelegate;
@interface GLSortTabBar : GLView


@property (nonatomic, assign)  id<GLSortTabBarDelegate> delegate;
// 隐藏底部分割线 default NO
@property (nonatomic, assign) BOOL      hideLineFlag;
// 左右Marin default 36
@property (nonatomic, assign) CGFloat   leftMargin;

@property(nonatomic,strong) UIFont      *font;            // default is GLFS_Px_28

@property(nonatomic,strong) UIColor     *textColor;       // default is GLTC_Black_404040

@property(nonatomic,strong) UIFont      *selectedFont;    // default is GLFS_Px_28

@property(nonatomic,strong) UIColor     *selectedTextColor;// default is GLTC_Red_C60A1E




- (void)fillData:(NSArray *)array;

- (void)selectItem:(NSString *)name type:(GLSortTabBarSortType)type;

- (void)selectIndex:(NSInteger)index type:(GLSortTabBarSortType)type;


@end



@protocol GLSortTabBarDelegate <NSObject>

@optional


- (void)sortTabBar:(GLSortTabBar *)sortTabBar selectedIndex:(NSInteger)index type:(GLSortTabBarSortType)type;


@end





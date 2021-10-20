//
//  GLSortTabBarItem.h
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 30/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <GLUIKit/GLUIKit.h>
#import "GLSortTabBar.h"

@interface GLSortTabBarItem : GLControl

@property (nonatomic, strong) GLLabel   *nameLabel;

@property (nonatomic, strong) NSString  *itemName;

@property (nonatomic, assign) GLSortTabBarSortType  sortType;

@property(nonatomic,strong) UIFont      *font;            // default is GLFS_Px_28

@property(nonatomic,strong) UIColor     *textColor;       // default is GLTC_Black_404040

@property(nonatomic,strong) UIFont      *selectedFont;    // default is GLFS_Px_28

@property(nonatomic,strong) UIColor     *selectedTextColor;// default is GLTC_Red_C60A1E





+ (CGFloat)viewWidthWithItemName:(NSString *)name;


@end

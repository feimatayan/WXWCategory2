//
//  GLSortTabBar.m
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 30/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#define kLeftMargin     36

#import "GLSortTabBar.h"
#import "GLSortTabBarItem.h"
#import "GLUIKitUtils.h"

@interface GLSortTabBar ()

// bottom line
@property (nonatomic, strong) GLView            *bottomLineView;

@property (nonatomic, strong) NSMutableArray    *itemViewArray;

@end


@implementation GLSortTabBar



+ (CGFloat)viewHeight
{
    return 40;
}

- (void)glSetup
{
    [super glSetup];
    
    self.backgroundColor = GLVC_Gray_F7F7F7;
    self.leftMargin = kLeftMargin;
    if (!self.bottomLineView) {
        self.bottomLineView = [[GLView alloc] init];
        self.bottomLineView.backgroundColor = GLUC_Line;
        [self addSubview:self.bottomLineView];
    }
    
    
    self.font = GLFS_Px_28;
    self.textColor = GLTC_Black_404040;
    self.selectedFont = GLFS_Px_28;
    self.selectedTextColor = GLTC_Red_C60A1E;
}

- (void)fillData:(NSArray *)array
{
    if (!(array && [array isKindOfClass:[array class]]))
    return;
    
    if (!self.itemViewArray) {
        self.itemViewArray = [[NSMutableArray alloc] init];
    } else {
        for (int i = 0; i < self.itemViewArray.count; i++) {
            GLSortTabBarItem *itemView = [self.itemViewArray objectAtIndex:i];
            [itemView removeFromSuperview];
        }
        [self.itemViewArray removeAllObjects];
    }
    
    for (int i = 0; i < array.count; i++) {
        GLSortTabBarItem *itemView = [[GLSortTabBarItem alloc] init];
        itemView.font = self.font;
        itemView.textColor = self.textColor;
        itemView.selectedFont = self.selectedFont;
        itemView.selectedTextColor = self.selectedTextColor;
        itemView.itemName = [array objectAtIndex:i];
        [itemView addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemViewArray addObject:itemView];
        [self addSubview:itemView];
        if (i == 0) {
            itemView.sortType = GLSortTabBarSortTypeUp;
        }
    }
    
    [self glCustomLayoutFrame:self.frame];;
}

- (void)itemClickAction:(GLSortTabBarItem *)item
{
    NSInteger index = [self.itemViewArray indexOfObject:item];
    for (int i = 0; i < self.itemViewArray.count; i++) {
        GLSortTabBarItem *itemView = [self.itemViewArray objectAtIndex:i];
        if (index == i) {
            itemView.sortType = GLSortTabBarSortTypeUp;
        } else {
            itemView.sortType = GLSortTabBarSortTypeNone;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sortTabBar:selectedIndex:type:)]) {
        [self.delegate sortTabBar:self selectedIndex:index type:item.sortType];
    }
}

- (void)selectItem:(NSString *)name type:(GLSortTabBarSortType)type
{
    if (name && [name isKindOfClass:[NSString class]]) {
        NSInteger index = -1;
        for (int i = 0; i < self.itemViewArray.count; i++) {
            GLSortTabBarItem *itemView = [self.itemViewArray objectAtIndex:i];
            if ([itemView.itemName isEqualToString:name]) {
                index = i;
                itemView.sortType = GLSortTabBarSortTypeNone;
                itemView.sortType = type;
            } else {
                itemView.sortType = GLSortTabBarSortTypeNone;
            }
        }
        
        if (index != -1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sortTabBar:selectedIndex:type:)]) {
                [self.delegate sortTabBar:self selectedIndex:index type:type];
            }
        }
    }
}

- (void)selectIndex:(NSInteger)index type:(GLSortTabBarSortType)type
{
    if (index < self.itemViewArray.count) {
        for (int i = 0; i < self.itemViewArray.count; i++) {
            GLSortTabBarItem *itemView = [self.itemViewArray objectAtIndex:i];
            if (i == index) {
                itemView.sortType = GLSortTabBarSortTypeNone;
                itemView.sortType = type;
            } else {
                itemView.sortType = GLSortTabBarSortTypeNone;
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sortTabBar:selectedIndex:type:)]) {
            [self.delegate sortTabBar:self selectedIndex:index type:type];
        }
    }
}

- (void)setHideLineFlag:(BOOL)hideLineFlag
{
    if (_hideLineFlag != hideLineFlag) {
        _hideLineFlag = hideLineFlag;
    }
    self.bottomLineView.hidden = self.hideLineFlag;
}

- (CGFloat)widthOfItems
{
    CGFloat w = 0;
    for (int i = 0; i < self.itemViewArray.count; i++) {
        GLSortTabBarItem *itemView = [self.itemViewArray objectAtIndex:i];
        w += [GLSortTabBarItem viewWidthWithItemName:itemView.itemName];
    }
    return w;
}

- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    
    if (self.itemViewArray.count > 1) {
        CGFloat x = self.leftMargin;
        CGFloat space = (self.width - [self widthOfItems] - x * 2)/(self.itemViewArray.count - 1);
        if (space > 0) {
            for (int i = 0; i < self.itemViewArray.count; i++) {
                GLSortTabBarItem *itemView = [self.itemViewArray objectAtIndex:i];
                itemView.frame = CGRectMake(x, 0, [GLSortTabBarItem viewWidthWithItemName:itemView.itemName], self.height);
                x += (itemView.width + space);
            }
        }
        self.bottomLineView.frame = CGRectMake(0, self.height - GL_HEIGHT_LINE, self.width , GL_HEIGHT_LINE);
    }
}

@end

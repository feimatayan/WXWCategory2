//
//  GLSortTabBarItem.m
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 30/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//


#define kGap    4
#define kWidth_ImageView    8
#define kHeight_ImageView   14

#import "GLSortTabBarItem.h"
#import "NSString+GLString.h"


@interface GLSortTabBarItem ()

@property (nonatomic, strong) GLImageView   *imageView;

@end


@implementation GLSortTabBarItem



+ (CGFloat)itemNameWidth:(NSString *)name
{
    CGFloat strWidth = [name glSizeWithFont:GLFS_Px_28].width;
    return strWidth;
}


+ (CGFloat)viewWidthWithItemName:(NSString *)name
{
    CGFloat w = 0;
    
    w += [GLSortTabBarItem itemNameWidth:name];
    w += (kGap * 2);
    w += (kWidth_ImageView * 2);
    
    return w;
}

- (void)glSetup
{
    [super glSetup];
    if (!self.nameLabel) {
        self.nameLabel = [[GLLabel alloc] init];
        [self addSubview:self.nameLabel];
    }
    
    if (!self.imageView) {
        self.imageView = [[GLImageView alloc] init];
        [self addSubview:self.imageView];
    }
    
    self.sortType = GLSortTabBarSortTypeNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setItemName:(NSString *)itemName
{
    self.nameLabel.text = itemName;
}



- (NSString *)itemName
{
    return self.nameLabel.text;
}



- (void)setSortType:(GLSortTabBarSortType)sortType
{
    if (_sortType != sortType) {
        _sortType = sortType;
    } else {
        if (_sortType == GLSortTabBarSortTypeUp) {
            _sortType = GLSortTabBarSortTypeDown;
        } else if (_sortType == GLSortTabBarSortTypeDown) {
            _sortType = GLSortTabBarSortTypeUp;
        } else {
            _sortType = sortType;
        }
    }
    
    BOOL showFlag = YES;
    if (_sortType == GLSortTabBarSortTypeUp) {
        self.imageView.image = [UIImage imageNamed:@"GLUIKit_SortTabBar_up"];
    } else if (_sortType == GLSortTabBarSortTypeDown) {
        self.imageView.image = [UIImage imageNamed:@"GLUIKit_SortTabBar_down"];
    } else {
        self.imageView.image = nil;
        showFlag = NO;
    }
    
    self.imageView.hidden = !showFlag;
    
    if (showFlag) {
        self.nameLabel.font = self.selectedFont?self.selectedFont:GLFS_Px_28;
        self.nameLabel.textColor = self.selectedTextColor?self.selectedTextColor:GLTC_Red_C60A1E;
    } else {
        self.nameLabel.font = self.font?self.font:GLFS_Px_28;
        self.nameLabel.textColor = self.textColor?self.textColor:GLTC_Black_404040;
    }
}


- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    
    CGFloat x = kWidth_ImageView + kGap;
    
    self.nameLabel.frame = CGRectMake(x, 0, [GLSortTabBarItem itemNameWidth:self.nameLabel.text], self.height);
    self.imageView.frame = CGRectMake(self.width - kWidth_ImageView, (self.height - kHeight_ImageView)/2, kWidth_ImageView, kHeight_ImageView);
}

@end

//
//  GLAssetsGroupCell.m
//  GLUIKit
//
//  Created by xiaofengzheng on 3/15/16.
//  Copyright © 2016 无线生活（北京）信息技术有限公司. All rights reserved.
//

#define kLeftMargin_ImageView       15



#import "GLAssetsGroupCell.h"
#import <GLUIKit/GLUIKit.h>
#import "GLFetchImageManager.h"
#import "GLCommonDef.h"


@interface GLAssetsGroupCell ()
{
    GLLabel     *_tileLabel;
    GLImageView *_imageView;
}

/// 标题
@property (nonatomic, strong) GLLabel       *tileLabel;
/// 缩略图
@property (nonatomic, strong) GLImageView   *iconImageView;

@property (nonatomic, strong) GLImageView   *arrowImageView;

@end

@implementation GLAssetsGroupCell

+ (CGFloat)viewHeight
{
    return 60;
}

- (CGSize)targetSize
{
    CGFloat border = [GLAssetsGroupCell viewHeight] * ([UIScreen mainScreen].scale);
    return CGSizeMake(border, border);
}


- (void)glSetup
{
    if (!_tileLabel) {
        _tileLabel = [[GLLabel alloc] init];
        [self addSubview:_tileLabel];
    }
    
    if (!_iconImageView) {
        _iconImageView = [[GLImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        [self addSubview:_iconImageView];
    }
    
    
    if (!_arrowImageView) {
        _arrowImageView = [[GLImageView alloc] init];
//        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_arrowImageView];
    }
}

- (void)fillData:(GLFetchImageGroup *)group
{
    if (group) {
        // title
        _tileLabel.text = group.title;
        // image
        GL_WEAK(self);
        [[GLFetchImageManager sharedInstance] fetchPostImageWithGroup:group targetSize:[self targetSize] completion:^(UIImage *postImage) {
            if (postImage) {
                weak_self.iconImageView.image = postImage;
            }
        }];
    }
}


- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    _iconImageView.frame = CGRectMake(kLeftMargin_ImageView, 0, self.height, self.height);
    self.leftMarginLine = _iconImageView.maxX;
    CGFloat x = _iconImageView.maxX + kLeftMargin_ImageView;
    _tileLabel.frame = CGRectMake(x, 0, self.width - x - kLeftMargin_ImageView * 2, self.height);
    
    UIImage *arrowImage = [UIImage imageNamed:@"GLPicker_icon_right_arrow"];
    CGSize arrowsize = CGSizeMake(floorf(arrowImage.size.width),
                                  floorf(arrowImage.size.height));
    CGFloat originX = GLUIKIT_SCREEN_WIDTH - 20;
    originX -= arrowsize.width;
    
    _arrowImageView.image = arrowImage;
    _arrowImageView.frame = CGRectMake(originX,
                                     (self.frame.size.height - arrowImage.size.height) / 2,
                                     arrowsize.width,
                                     arrowsize.height);
}


@end

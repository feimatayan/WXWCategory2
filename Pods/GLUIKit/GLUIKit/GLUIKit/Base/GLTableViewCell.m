//
//  GLTableViewCell.m
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLTableViewCell.h"
#import "GLUIKitUtils.h"
#import "GLView+GLFrame.h"


@interface GLTableViewCell ()
{
    /// 底部分割线
    UILabel     *_bottomLineLabel;
}

@end

@implementation GLTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self glSetup];
        // 底部分割线
        if (!_bottomLineLabel) {
            _bottomLineLabel = [[UILabel alloc] init];
            _bottomLineLabel.backgroundColor = UIColorFromRGB(0xe5e5e5);
            [self.contentView addSubview:_bottomLineLabel];
        }
    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self glCustomLayoutFrame:frame];
    CGFloat x = (_leftMarginLine ? _leftMarginLine : 10);
    if (_fullLineFlag) {
        x = 0;
    }
    _bottomLineLabel.frame = CGRectMake(x, self.height - GL_HEIGHT_LINE, self.width - x - _rightMarginLine, GL_HEIGHT_LINE);
    _bottomLineLabel.hidden = _hideLineFlag;
    [self.contentView bringSubviewToFront:_bottomLineLabel];
}

- (void)glSetup
{
    // TODO SUBCLASS
}


- (void)glCustomLayoutFrame:(CGRect)frame
{
    // TODO SUBCLASS
}


@end

//
//  GLLimitedStatusView.m
//  GLImagePicker
//
//  Created by zhangylong on 2020/11/16.
//

#import "GLLimitedStatusView.h"

#import "GLCommonDef.h"

@interface GLLimitedStatusView ()

@end


@implementation GLLimitedStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xfff4de);
        
        [self initViews:self.bounds];
    }
    return self;
}

- (void)initViews:(CGRect)frame {
    CGFloat margin = 10.5, right = 34.0;
    CGFloat x=margin,y=13.0;
    
    CGFloat fontSize = 12.0;
    CGFloat gap = 5.0;

    CGRect frameOfLabel = CGRectMake(x, y, frame.size.width - x - right, fontSize);
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:frameOfLabel];
    promptLabel.textColor = UIColorFromRGB(0xfe5a4c);
    promptLabel.font = [UIFont systemFontOfSize:fontSize];
    promptLabel.text = @"无法访问相册中所有照片。";
    [self addSubview:promptLabel];
    
    CGRect frameOfLabel2 = frameOfLabel;
    frameOfLabel2.origin.y += (frameOfLabel.size.height + gap);
    UILabel *promptLabel2 = [[UILabel alloc] initWithFrame:frameOfLabel2];
    promptLabel2.textColor = UIColorFromRGB(0xfe5a4c);
    promptLabel2.font = [UIFont systemFontOfSize:fontSize];
    promptLabel2.text = @"可修改系统设置允许访问「照片」中的「所有照片」。";
    [self addSubview:promptLabel2];
    
    UIImage *arrowImage = [UIImage imageNamed:@"GLPicker_icon_limited_right_arrow"];
    CGFloat arrowWidth = arrowImage.size.width;
    CGFloat arrowHeight = arrowImage.size.height;
    x = frame.size.width- 18;
    y = (frame.size.height - arrowHeight) / 2;
    CGRect frameOfArrow = CGRectMake(x, y, arrowWidth, arrowHeight);
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:frameOfArrow];
    arrowView.image = arrowImage;
    [self addSubview:arrowView];
    
    UIControl *clickControl = [[UIControl alloc] initWithFrame:frame];
    [clickControl addTarget:self action:@selector(clickOpenPhotoSetting) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickControl];
}

- (void)clickOpenPhotoSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end

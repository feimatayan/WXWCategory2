//
//  SyTableFooterView.m
//  Dajia
//
//  Created by zhengxiaofeng on 13-7-8.
//  Copyright (c) 2013年 zhengxiaofeng. All rights reserved.
//

#define kBorder_ActivityView        20
#define kLeftMargin_Label           6


#import "GLRefreshTableFooterView.h"
#import "GLUIKitUtils.h"
#import "GLLabel.h"
#import "NSString+GLString.h"
#import "UIView+GLFrame.h"


@interface GLRefreshTableFooterView ()
{
    // style label
    GLLabel                     *_label;
    UIActivityIndicatorView     *_activityView;
}

@end


@implementation GLRefreshTableFooterView



- (void)glSetup
{
    [super glSetup];
    
    if (!_label) {
        _label                  = [[GLLabel alloc] init];
        _label.font             = [UIFont boldSystemFontOfSize:14.0f];
        _label.textColor        = UIColorFromRGB(0x9a9a9a);
//        _label.shadowColor      = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        _label.shadowOffset     = CGSizeMake(0.0f, 1.0f);
        _label.backgroundColor  = [UIColor clearColor];
        _label.textAlignment    = NSTextAlignmentCenter;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_label];
    }
    
    if (!_activityView) {
        _activityView           = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        [self addSubview:_activityView];
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize labelSize = [_label.text glSizeWithFont:_label.font constrainedToSize:CGSizeMake(self.width, CGFLOAT_MAX)];
    
    if (self.currentStyle == GLRefreshTableFooterViewNoData) {
        CGFloat x = (self.width - (labelSize.width + 4))/2;
        _activityView.frame = CGRectZero;
        _label.frame = CGRectMake(x, 20, labelSize.width + 4, 20);
    } else {
        CGFloat x = (self.width - (labelSize.width + kBorder_ActivityView + kLeftMargin_Label))/2;
        _activityView.frame = CGRectMake(x, 20, kBorder_ActivityView, kBorder_ActivityView);
        x += (kBorder_ActivityView + kLeftMargin_Label);
        _label.frame = CGRectMake(x, 20, labelSize.width, 20);
    }
    
    
}



- (void)updateStyle:(GLRefreshTableFooterViewStyle)style
{
    self.currentStyle = style;
    
    switch (style) {
        case GLRefreshTableFooterViewPull: {
            _label.text = @"";
            [_activityView stopAnimating];
            self.hidden = YES;
            break;
        }
        case GLRefreshTableFooterViewRelease: {
            _label.text = @"正在加载...";
            [_activityView stopAnimating];
            self.hidden = NO;
            break;
        }
        case GLRefreshTableFooterViewLoading:{
            _label.text = @"正在加载...";
            [_activityView startAnimating];
            self.hidden = NO;
            break;
        }
        case GLRefreshTableFooterViewNoData: {
            _label.text = @"已经到最后了";
            [_activityView stopAnimating];
            self.hidden = NO;
            break;
        }
            
        default:
            break;
    }
    [self setNeedsLayout];

}


@end

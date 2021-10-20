//
//  SyTableHeaderView.m
//  Dajia
//
//  Created by zhengxiaofeng on 13-7-8.
//  Copyright (c) 2013年 zhengxiaofeng. All rights reserved.
//
#define kWidth_ArrowImageView       22
#define kHeight_ArrowImageView      22
#define kLeftMargin_ArrowImageView  86
#define kWidth_ActivityView         20
#define kHeight_ActivityView        20


#import "GLRefreshTableHeaderView.h"
#import "GLRefreshTableViewConstant.h"
#import "GLDateUtil.h"
#import "GLUIKitUtils.h"
#import "GLLabel.h"
#import "GLView.h"
#import "GLImageView.h"
#import "GLActivityIndicatorView.h"
#import "NSString+GLString.h"


@interface GLRefreshTableHeaderView ()
{
    
    /// style label
    GLLabel                     *_pullLabel;
    /// time label
    GLLabel                     *_timeLabel;
    /// back view
    GLView                      *_pullView;
    /// icon imageView
    GLImageView                 *_imageView;
    /// loading label
    UIActivityIndicatorView     *_activityView;
}


@end



@implementation GLRefreshTableHeaderView


- (void)glSetup
{
    [super glSetup];
    
    self.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    // bk view
    if (!_pullView) {
        _pullView                   = [[GLView alloc] init];
        _pullView.backgroundColor   = [UIColor clearColor];
        [self addSubview:_pullView];
    }
    
    // style label
    if (!_pullLabel) {
        _pullLabel                  = [[GLLabel alloc] init];
        _pullLabel.backgroundColor  = [UIColor clearColor];
        _pullLabel.font             = [UIFont boldSystemFontOfSize:14.0f];
        _pullLabel.textColor        = UIColorFromRGB(0x666666);
//        _pullLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        _pullLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _pullLabel.textAlignment = NSTextAlignmentLeft;
        [_pullView addSubview:_pullLabel];
    }
    // time label
    if (!_timeLabel) {
        _timeLabel = [[GLLabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = UIColorFromRGB(0x9D9D9D);
//        _timeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        _timeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [_pullView addSubview:_timeLabel];
    }
    // icon imageview
    if (!_imageView) {
        _imageView = [[GLImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"GLUIKit_refresh_arrow_down"];
        [self addSubview:_imageView];
    }
    
    // activity view
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        [self addSubview:_activityView];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _pullView.frame = CGRectMake(0,
                                 self.height - kHeight_HeaderView,
                                 self.width,
                                 kHeight_HeaderView);
    
 
    CGSize pullLabelSize = [_pullLabel.text glSizeWithFont:_pullLabel.font constrainedToSize:CGSizeMake(_pullView.width, _pullView.height)];
    _pullLabel.frame = CGRectMake((self.width - pullLabelSize.width)/2,
                                  10,
                                  pullLabelSize.width * 2,
                                  20);
    CGSize timeLabelSize = [_timeLabel.text glSizeWithFont:_timeLabel.font
                                       constrainedToSize:CGSizeMake(_pullView.width, _pullView.height)];
    _timeLabel.frame = CGRectMake(_pullLabel.x, 30, timeLabelSize.width + 10, 20);
    _imageView.frame = CGRectMake(_pullLabel.x - kWidth_ArrowImageView - 10,
                                  self.height - (kHeight_HeaderView - kHeight_ArrowImageView)/2.0 - kHeight_ArrowImageView,
                                  kWidth_ArrowImageView,
                                  kHeight_ArrowImageView);
    
    _activityView.frame = CGRectMake(_pullLabel.x - kWidth_ArrowImageView - 10,
                                     self.height - (kHeight_HeaderView - kHeight_ActivityView)/2.0 - kHeight_ActivityView,
                                     kWidth_ActivityView,
                                     kHeight_ActivityView);
    
}




- (void)updateStyle:(GLRefreshTableHeaderViewStyle)style
{
    self.currentStyle = style;
    
    // last time
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:kTableLastRefreshDate];
    
    if (!time) {
        _timeLabel.text = @"未更新";
    } else {
        NSString *timeStr = [GLDateUtil localDateByDay:time hasTime:YES];
        _timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最近更新: %@", @"label"),timeStr];
    }
    
    
    switch (style) {
        case GLRefreshTableHeaderViewStylePull: {
            // 下拉
            [self rotateImage:NO animated:YES];
            [self setActivityView: NO];
            _pullLabel.text = @"下拉刷新";
            
            break;
        }
        case GLRefreshTableHeaderViewStyleRelease: {
            // 释放
            [self rotateImage:YES animated:YES];
            [self setActivityView: NO];
            _pullLabel.text = @"松开刷新";
            break;
        }
        case GLRefreshTableHeaderViewStyleLoading: {
            // 加载中
            [self rotateImage:NO animated:YES];
            [self setActivityView: YES];
            _pullLabel.text = @"加载中...";
            break;
        }
        default:
            break;
    }
}





/**
 *  brief 旋转 icon
 *
 *  @param rotate   旋转 flag
 *  @param animated 动画 flag
 */
- (void)rotateImage:(BOOL)rotate animated:(BOOL)animated
{
    //
    BOOL previousFlip = !CGAffineTransformIsIdentity(_imageView.transform);
    
    if (rotate == previousFlip) {
        return;
    }
    
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.18];
	}
	if (!rotate) {
		_imageView.transform = CGAffineTransformIdentity;
	}
	else {
		_imageView.transform = CGAffineTransformMakeRotation(M_PI);
	}
    
	if (animated) {
		[UIView commitAnimations];
	}
}


/**
 *  @brief 设置 loading 是否打开
 *
 *  @param isON 开关状态
 */
- (void)setActivityView:(BOOL)isON
{
    _imageView.hidden = isON;
    if (isON) {
        [_activityView startAnimating];
    } else {
        [_activityView stopAnimating];
    }
}



/**
 *  @brief 显示加载 漏出 headveiw
 *
 *  @param tableView
 *  @param animated  动画flag
 */
- (void)startLoading:(UITableView *)tableView animated:(BOOL)animated
{
    if (_currentStyle != GLRefreshTableHeaderViewStyleLoading) {
        [self updateStyle:GLRefreshTableHeaderViewStyleLoading];
        __weak UITableView *weakTableview = tableView;
        
        if (animated) {
            [UIView animateWithDuration:0.2 animations:^{
                // CGFloat top, left, bottom, right;
                weakTableview.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            } completion:^(BOOL finished) {
                
            }];
        } else {
            // CGFloat top, left, bottom, right;
            weakTableview.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        }
    }
}

/**
 *  @brief 结束加载 并隐藏 headView
 *
 *  @param tableView
 *  @param animated  动画flag
 */
- (void)finishLoading:(UITableView *)tableView animated:(BOOL)animated
{
    if (_currentStyle == GLRefreshTableHeaderViewStyleLoading) {
        __weak UITableView *weakTableview = tableView;
        __weak typeof (self) weakself = self;
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                [weakTableview setContentInset:UIEdgeInsetsZero];
            } completion:^(BOOL finished) {
                [weakself viewFinishAnimation];
            }];
        } else {
            [weakTableview setContentInset:UIEdgeInsetsZero];
            [self viewFinishAnimation];
        }
    }
}

- (void)viewFinishAnimation
{
    [self updateStyle:GLRefreshTableHeaderViewStylePull];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate *lastUpdatedDate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [formatter stringFromDate:lastUpdatedDate];
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:kTableLastRefreshDate];
    NSString *dateStr = [NSString stringWithFormat:NSLocalizedString(@"最近更新: %@", @"label"),[GLDateUtil localDateByDay:time hasTime:YES]];
    _timeLabel.text = dateStr;
    
}

@end

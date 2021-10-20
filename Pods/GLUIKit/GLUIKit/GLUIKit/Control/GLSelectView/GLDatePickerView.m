//
//  GLDatePickerView.m
//  WDPlugin_MyVDian
//
//  Created by xiaofengzheng on 12/23/15.
//  Copyright © 2015 Koudai. All rights reserved.
//


#define kLeftMarginButton       10
#define kWidthButton            70
#define kHeight_PickerView      190
#define kHeight_TopBarView      50
#define kHeight_TopLineView     (1 / [UIScreen mainScreen].scale)

#import "GLDatePickerView.h"
#import "GLUIKitUtils.h"
#import "GLDatePicker.h"


NSString *const KDatePickerViewWillShowNotification = @"GLDatePickerViewWillShowNotification";
NSString *const KDatePickerViewWillHideNotification = @"GLDatePickerViewWillHideNotification";



@interface GLDatePickerView ()
{
    GLView              *_topBarView;
    BOOL                _dismissCalledFlag;
}

/// 选择器
@property (nonatomic, strong) GLDatePicker  *pickerView;
/// 取消button
@property (nonatomic, strong) GLButton      *cancelButton;
/// 确定button
@property (nonatomic, strong) GLButton      *sureButton;
/// 顶部分割线
@property (nonatomic, strong) GLView		*topLineView;
/// 是否已展示
@property (nonatomic, assign) BOOL          isShow;

/// 消失回调
@property (nonatomic, copy) dismissCompletion           dismissCompletion;


@property (nonatomic, copy) finishCompletion            finishCompletion;

@end


@implementation GLDatePickerView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview && !_dismissCalledFlag) {
        if (self.finishCompletion) {
            self.finishCompletion(YES,nil);
        }
    }
}


+ (CGFloat)viewHeight
{
    return kHeight_PickerView + kHeight_TopBarView;
}



- (void)glSetup
{
    [super glSetup];
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_topBarView) {
        _topBarView = [[GLView alloc] init];
		_topBarView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self addSubview:_topBarView];
    }
    
    
    if (_topBarView) {
        self.cancelButton = [GLButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
		[self.cancelButton setTitleColor:UIColorFromRGB(0x4384d8) forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_topBarView addSubview:self.cancelButton];
        
        
        self.sureButton = [GLButton buttonWithType:UIButtonTypeCustom];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
		[self.sureButton setTitleColor:UIColorFromRGB(0x4384d8) forState:UIControlStateNormal];
        [_topBarView addSubview:self.sureButton];
		
		self.topLineView = [[GLView alloc] init];
		self.topLineView.backgroundColor = UIColorFromRGB(0xcacaca);
		[_topBarView addSubview:self.topLineView];
    }
    
    
    
    self.pickerView = [[GLDatePicker alloc] init];
    [self addSubview:self.pickerView];
    
}


- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    
    _topBarView.frame = CGRectMake(0, 0, self.width, kHeight_TopBarView);
	self.topLineView.frame = CGRectMake(0, 0, self.width, kHeight_TopLineView);
    self.cancelButton.frame = CGRectMake(kLeftMarginButton, 0, kWidthButton, _topBarView.height);
    self.sureButton.frame = CGRectMake(self.width - kLeftMarginButton - kWidthButton, 0, kWidthButton, _topBarView.height);
    _pickerView.frame = CGRectMake(0, _topBarView.height, self.width, self.height - _topBarView.height);
    
}

- (void)cancelButtonAction
{
    [self dismissDatePickerViewIsCancel:YES isDismiss:NO];
}


- (void)sureButtonAction
{
    [self dismissDatePickerViewIsCancel:NO isDismiss:NO];
}




- (void)presentDatePickerViewOn:(GLViewController *)onViewController mode:(UIDatePickerMode)pickerMode selected:(NSDate *)selectedDate finishCompletion:(void (^)(BOOL, NSDictionary *))completion
{
    
    if (!_isShow) {
        _isShow = YES;
    
        if (pickerMode) {
            self.pickerView.datePickerMode = pickerMode;
        } else {
            self.pickerView.datePickerMode = UIDatePickerModeDate;
        }
        
        if (selectedDate) {
            self.pickerView.date = selectedDate;
        }
        
        CGFloat w = onViewController.view.bounds.size.width;
        CGFloat h = onViewController.view.bounds.size.height;
        
        self.frame = CGRectMake(0, h,w, [GLDatePickerView viewHeight]);
        [onViewController.view addSubview:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KDatePickerViewWillShowNotification object:self];
        GL_WEAK(self);
        [UIView animateWithDuration:0.3 animations:^{
            weak_self.frame = CGRectMake(0, h - [GLDatePickerView viewHeight], w, [GLDatePickerView viewHeight]);
        } completion:^(BOOL finished) {
            weak_self.finishCompletion = completion;
            
        }];
    }
    
}


- (NSDictionary *)getSelectDate
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"0"] = self.pickerView.date;
    return dic;
}


- (void)dismissDatePickerViewCompletion:(dismissCompletion)completion
{
    self.dismissCompletion = completion;
    [self dismissDatePickerViewIsCancel:YES isDismiss:YES];
}

- (void)dismissDatePickerViewIsCancel:(BOOL)isCancel isDismiss:(BOOL)isDismiss
{
    CGFloat w = self.width;
    CGFloat y = self.y;
    _dismissCalledFlag = YES;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KDatePickerViewWillHideNotification object:self];
    GL_WEAK(self);
    [UIView animateWithDuration:0.3 animations:^{
        weak_self.frame = CGRectMake(0, y + [GLDatePickerView viewHeight], w, [GLDatePickerView viewHeight]);
    } completion:^(BOOL finished) {
        if (!isDismiss) {
            if (weak_self.finishCompletion) {
                NSDictionary *dic = [weak_self getSelectDate];
                if (isCancel) {
                    dic = nil;
                }
                weak_self.finishCompletion(isCancel,dic);
            }
        } else {
            if (weak_self.dismissCompletion) {
                weak_self.dismissCompletion();
            }
        }
       
        [weak_self removeFromSuperview];
    }];
}





@end

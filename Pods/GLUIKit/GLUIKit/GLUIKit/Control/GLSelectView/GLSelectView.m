//
//  GLSelectView.m
//  WDPlugin_MyVDian
//
//  Created by xiaofengzheng on 12/22/15.
//  Copyright © 2015 Koudai. All rights reserved.
//

#define kLeftMarginButton       10
#define kWidthButton            70
#define kHeight_PickerView      190
#define kHeight_TopBarView      50
#define kHeight_Row             40
#define kHeight_TopLineView     (1 / [UIScreen mainScreen].scale)


#import "GLSelectView.h"
#import "GLSelectNode.h"
#import "GLUIKitUtils.h"
#import "GLUIKit.h"


NSString *const KSelectViewWillShowNotification = @"GLSelectViewWillShowNotification";
NSString *const KSelectViewWillHideNotification = @"GLSelectViewWillHideNotification";



@interface GLSelectView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    GLView              *_topBarView;
    
    BOOL                _dismissCalledFlag;
}

/// 选择器
@property (nonatomic, strong) UIPickerView  *pickerView;
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

/// 取消/确定 回调
@property (nonatomic, copy) finishCompletion            finishCompletion;

/// 数据 二维数组
@property (nonatomic, retain) NSArray                   *dataArray;
/// 当前选择 的key，value
@property (nonatomic, retain) NSMutableDictionary       *currentSelectedDic;

@end




@implementation GLSelectView


+ (CGFloat)viewHeight
{
    return kHeight_PickerView + kHeight_TopBarView;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview && !_dismissCalledFlag) {
        if (self.finishCompletion) {
            self.finishCompletion(YES,nil);
        }
    }
}


- (void)glSetup
{
    [super glSetup];
    
    self.backgroundColor = [UIColor whiteColor];
    self.rowHeight = kHeight_Row;
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
		[self.sureButton setTitleColor:UIColorFromRGB(0x4384d8) forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_topBarView addSubview:self.sureButton];
		
		self.topLineView = [[GLView alloc] init];
		self.topLineView.backgroundColor = UIColorFromRGB(0xcacaca);
		[_topBarView addSubview:self.topLineView];
    }

    if (!self.pickerView) {
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
    }
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
    [self hideSelectViewIsCancel:YES isDismiss:NO];
}


- (void)sureButtonAction
{
    [self hideSelectViewIsCancel:NO isDismiss:NO];
}


#pragma mark- UIPickerViewDataSource,UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _dataArray.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = [_dataArray objectAtIndex:component];
    return array.count;
}

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 20;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = [_dataArray objectAtIndex:component];
    
    id obj = [array objectAtIndex:row];
    if ([obj isKindOfClass:[GLSelectNode class]]) {
        return [(GLSelectNode *)obj title];
    }
    
    return [array objectAtIndex:row];
}
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return nil;
//}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
//{
//    return nil;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
#ifdef DEBUG
    NSLog(@"%zd,%zd",row,component);
#endif
    
    NSString *key = [NSString stringWithFormat:@"%zd",component];
    NSString *value = @"";
    NSArray *array = [self.dataArray objectAtIndex:component];
    if (array.count > 0) {
        value = [array objectAtIndex:row];
    }
    [self.currentSelectedDic setObject:value?value:@"" forKey:key];
}


#pragma mark- public
- (void)presentSelectViewOn:(GLViewController *)onViewController data:(NSArray<NSArray *> *)array selected:(NSArray<NSIndexPath *> *)selectedArray finishCompletion:(void (^)(BOOL, NSDictionary *))completion
{

    if (!_isShow) {
        _isShow = YES;
        
        if (!self.currentSelectedDic) {
            self.currentSelectedDic = [[NSMutableDictionary alloc] init];
        } else {
            [self.currentSelectedDic removeAllObjects];
        }
        
        
        if (array.count > 0) {
            NSObject *obj = [array objectAtIndex:0];
            if (![obj isKindOfClass:[NSArray class]]) {
                self.dataArray = @[array];
            } else {
                self.dataArray = array;
            }
            
            for (int i = 0; i < self.dataArray.count; i++) {
                NSArray *array = [self.dataArray objectAtIndex:i];
                NSString *key = [NSString stringWithFormat:@"%d",i];
                
                NSString *value = @"";
                if (array.count > 0) {
                    value = [array objectAtIndex:0];
                }
                [self.currentSelectedDic setObject:value?value:@"" forKey:key];
            }
        }
        
        CGFloat w = onViewController.view.bounds.size.width;
        CGFloat h = onViewController.view.bounds.size.height;
        
        self.frame = CGRectMake(0, h,w, [GLSelectView viewHeight]);
        [self.pickerView reloadAllComponents];
        [onViewController.view addSubview:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KSelectViewWillShowNotification object:self];
        GL_WEAK(self);
        [UIView animateWithDuration:0.3 animations:^{
            weak_self.frame = CGRectMake(0, h - [GLSelectView viewHeight], w, [GLSelectView viewHeight]);
        } completion:^(BOOL finished) {
            weak_self.finishCompletion = completion;
            for (int i = 0; i < selectedArray.count; i++) {
                NSIndexPath *indexPath = [selectedArray objectAtIndex:i];
                [weak_self.pickerView selectRow:indexPath.row inComponent:indexPath.section animated:NO];
                NSString *key = [NSString stringWithFormat:@"%zd",indexPath.section];
                
                NSString *value = @"";
                NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
                if (array.count > 0) {
                    value = [array objectAtIndex:indexPath.row];
                }
                [weak_self.currentSelectedDic setObject:value?value:@"" forKey:key];
            }
            
        }];
    }
}


- (void)dismissSelectViewCompletion:(dismissCompletion)completion
{
    self.dismissCompletion = completion;
    [self hideSelectViewIsCancel:YES isDismiss:YES];
}


#pragma mark- private

- (void)hideSelectViewIsCancel:(BOOL)isCancel isDismiss:(BOOL)isDismiss
{
    CGFloat w = self.width;
    CGFloat y = self.y;
    _dismissCalledFlag = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KSelectViewWillShowNotification object:self];
    GL_WEAK(self);
    [UIView animateWithDuration:0.3 animations:^{
        weak_self.frame = CGRectMake(0, y + [GLSelectView viewHeight], w, [GLSelectView viewHeight]);
    } completion:^(BOOL finished) {
        if (!isDismiss) {
            if (weak_self.finishCompletion) {
                if (isCancel) {
                    self.currentSelectedDic = nil;
                }
                
                weak_self.finishCompletion(isCancel,self.currentSelectedDic);
                
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

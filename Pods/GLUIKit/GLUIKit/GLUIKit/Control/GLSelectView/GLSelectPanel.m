//
//  GLSelectPanel.m
//  WDPlugin_CRM
//
//  Created by xiaofengzheng on 12/26/15.
//  Copyright © 2015 baoyuanyong. All rights reserved.
//

#define kLeftMarginButton       10
#define kWidthButton            70
#define kHeight_PickerView      190
#define kHeight_TopBarView      50
#define kHeight_TopLineView     (1 / [UIScreen mainScreen].scale)

#import "GLUIKitUtils.h"
#import "GLSelectView.h"
#import "GLSelectPanel.h"
#import "GLSelectNode.h"
#import "GLButton.h"


NSString *const KSelectPanelWillShowNotification = @"GLSelectPanelWillShowNotification";
NSString *const KSelectPanelWillHideNotification = @"GLSelectPanelWillHideNotification";


@interface GLSelectPanel ()<UIPickerViewDataSource,UIPickerViewDelegate>
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

/// 根节点
@property (nonatomic, retain) GLSelectNode              *rootNode;

@property (nonatomic, assign) NSInteger                 sectionCount;

@property (nonatomic, strong) NSMutableArray            *sectionArray;




@end

@implementation GLSelectPanel



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
    return self.sectionCount;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    GLSelectNode *select = [self.sectionArray objectAtIndex:component];
    return select.subArray.count;

}



// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 20;
//}
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 80;
//}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g GLLabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    GLSelectNode *select = [self.sectionArray objectAtIndex:component];
    
    return [(GLSelectNode *)[select.subArray objectAtIndex:row] title];
}
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return nil;
//}
//- (GLView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable GLView *)view
//{
//    return nil;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    GLSelectNode *sectionNode = [self.sectionArray objectAtIndex:component];
    
    GLSelectNode *selectNode = [sectionNode.subArray objectAtIndex:row];
    
    NSInteger nextComponent = component + 1;
    
    if (nextComponent < self.sectionArray.count) {
        
        [self.sectionArray replaceObjectAtIndex:nextComponent withObject:selectNode];
        // 默认选中 0
        [pickerView reloadComponent:nextComponent];
        [pickerView selectRow:0 inComponent:nextComponent animated:YES];
        
        for (NSInteger i = nextComponent; i < self.sectionCount; i++) {
            GLSelectNode *node = [self.sectionArray objectAtIndex:i];
            NSInteger next = i + 1;
            if (node.subArray.count > 0 && next < self.sectionArray.count) {
                [self.sectionArray replaceObjectAtIndex:next withObject:[node.subArray objectAtIndex:0]];
                [pickerView reloadComponent:next];
                [pickerView selectRow:0 inComponent:next animated:YES];

            }
        }
    }
    [pickerView reloadAllComponents];
    
}


- (NSDictionary *)getSelectedInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.sectionArray.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%zd",i];
        NSInteger index = [_pickerView selectedRowInComponent:i];
        
        GLSelectNode *sectionNode = [self.sectionArray objectAtIndex:i];
        GLSelectNode *selectNode = [sectionNode.subArray objectAtIndex:index];
        [dic setObject:selectNode forKey:key];
    }
    return dic;
}



#pragma mark- public
- (void)presentNodeSelectPanelOn:(GLViewController *)onViewController data:(GLSelectNode *)rootNode selected:(NSArray<GLSelectNode *> *)selectNodeArray finishCompletion:(void (^)(BOOL, NSDictionary *))completion
{
    
    if (!_isShow) {
        _isShow = YES;
    
        self.rootNode = rootNode;
        self.sectionCount = ([GLSelectNode checkLayer:rootNode] - 1);
        
        if (!self.sectionArray) {
            self.sectionArray = [[NSMutableArray alloc] init];
        } else {
            [self.sectionArray removeAllObjects];
        }
        
        
        // section 数据
        for (int i = 0; i < self.sectionCount; i++) {
           
            if (self.sectionArray.count > 0) {
                NSInteger preIndex = (i - 1);
                GLSelectNode *preNode = [self.sectionArray objectAtIndex:preIndex];
                
                if (preIndex < selectNodeArray.count) {
                    GLSelectNode *findNode = [selectNodeArray objectAtIndex:preIndex];
                    
                    GLSelectNode *currentNode = [GLSelectNode findeSameNode:findNode inArray:preNode.subArray isRelation:YES];
                    if (currentNode) {
                        [self.sectionArray addObject:currentNode];
                    }
                } else {
                    if (preNode.subArray.count > 0) {
                        // next Node
                        [self.sectionArray addObject:[preNode.subArray objectAtIndex:0]];
                    }
                }
                
            } else {
                // root Node
                [self.sectionArray addObject:self.rootNode];
                
            }
        }
        
        
        
        CGFloat w = onViewController.view.bounds.size.width;
        CGFloat h = onViewController.view.bounds.size.height;
        
        self.frame = CGRectMake(0, h,w, [GLSelectView viewHeight]);
        [self.pickerView reloadAllComponents];
        [onViewController.view addSubview:self];
        
        
        // 选择
        for (int i = 0; i < self.sectionArray.count; i++) {
            GLSelectNode *sectionNode = [self.sectionArray objectAtIndex:i];
            
            if (i < selectNodeArray.count) {
                GLSelectNode *findeNode = [selectNodeArray objectAtIndex:i];
                GLSelectNode *retNode = [GLSelectNode findeSameNode:findeNode inArray:sectionNode.subArray isRelation:YES];
                [_pickerView selectRow:retNode.index inComponent:i animated:NO];
                
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KSelectPanelWillShowNotification object:self];
        GL_WEAK(self);
        [GLView animateWithDuration:0.3 animations:^{
            weak_self.frame = CGRectMake(0, h - [GLSelectView viewHeight], w, [GLSelectView viewHeight]);
        } completion:^(BOOL finished) {
            weak_self.finishCompletion = completion;
            
            
        }];
    }
}

- (void)dismissNodeSelectPanelCompletion:(dismissCompletion)completion
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KSelectPanelWillHideNotification object:self];
    GL_WEAK(self);
    [GLView animateWithDuration:0.3 animations:^{
        weak_self.frame = CGRectMake(0, y + [GLSelectView viewHeight], w, [GLSelectView viewHeight]);
    } completion:^(BOOL finished) {
        if (!isDismiss) {
            if (weak_self.finishCompletion) {
                NSDictionary *dic = [self getSelectedInfo];
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

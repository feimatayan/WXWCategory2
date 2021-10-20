//
//  GLAlertViewController.m
//  GLUIKit
//
//  Created by Kevin on 15/10/14.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLAlertViewController.h"
#import "GLUIKitUtils.h"

#define kWDAlertViewCancelButtonDefaultTitle @"取消"

static id kWDStrongSelf;


@interface GLAlertViewController ()

@property (nonatomic, strong)NSMutableDictionary *actionsMap;

/// 外部是否添加了取消按钮，default NO
@property (assign) BOOL hadAddCancelButton;

/// 取消按钮标题
@property (copy) NSString *cancelTitle;

/// 取消按钮响应事件
@property (copy) GLAlertViewClickBlock cancelBlock;

/// 取消按钮的index
@property (assign) NSInteger cancelIndex;

@end


static BOOL kAlertViewHasShow   = NO;
static NSUInteger kAlertViewTag = NSUIntegerMax;


@implementation GLAlertViewController

- (void)dealloc
{
    
}

#pragma mark - init
#pragma mark - 

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)initWithStyle:(GLAlertViewStyle)style title:(NSString *)title msg:(NSString *)msg
{
    if (self = [self init]) {
        
        _style        = style;
        _alertTitle   = title;
        _alertMessage = msg;
    }
    return self;
}


- (void)_initialize
{
    _actionsMap = [NSMutableDictionary dictionary];
    _cancelIndex = NSIntegerMin;
    _useNSAlertView = NO;
}


#pragma mark - 
#pragma mark -

- (void)addButtonWithIndex:(NSUInteger)index
                     title:(NSString *)title
                clickBlock:(GLAlertViewClickBlock)clickBlock
{
    NSAssert(index >= 0, @"index must be greater than or equal to zero");
    NSString *key = [NSString stringWithFormat:@"%ld", (unsigned long)index];
    NSMutableDictionary *value = [NSMutableDictionary dictionary];
    
    if (title) {
        
        if (!_hadAddCancelButton
            && [title isEqualToString:kWDAlertViewCancelButtonDefaultTitle]
            && _style == GLAlertViewStyleActionSheet) {
            
            self.hadAddCancelButton = YES;
            self.cancelBlock = clickBlock;
            self.cancelTitle = title;
            self.cancelIndex = index;
            
            //MARK: [Acorld] ---->兼容老实现方法：如果设置了取消，则沿用老规则（保存设置，return，show时统一设置）
            
            return;
        }
        else {
            value[@"title"] = title;
        }
    }
    
    if (clickBlock) {
        value[@"block"] = [clickBlock copy];
    }
    [_actionsMap setObject:value forKey:key];
}

- (void)addCancelButtonWithTitle:(NSString *)title
                      clickBlock:(GLAlertViewClickBlock)clickBlock
{
    self.hadAddCancelButton = YES;
    self.cancelBlock        = clickBlock;
    self.cancelTitle        = title;
}

#ifdef  __IPHONE_8_0
- (UIAlertController *)prepareAlertViewForiOS8
{
    UIAlertController *ac = nil;
    
    switch (_style) {
        case GLAlertViewStyleActionSheet:
        {
            ac = [UIAlertController alertControllerWithTitle:_alertTitle
                                                     message:_alertMessage
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        }
            break;
        case GLAlertViewStyleAlert:
        {
            ac = [UIAlertController alertControllerWithTitle:_alertTitle
                                                     message:_alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        }
            break;
            
        default:
            break;
    }
    
    ac.title = self.alertTitle;
    
    // 2017.3.8 zhengxf 去掉判断
//    if (!self.alertTitle || self.alertTitle.length == 0) {
//        ac.title = nil;
//    }
//    if (!self.alertMessage || self.alertMessage.length == 0) {
//        ac.message = nil;
//    }
    
    NSArray *sortedKeys = [self _sortedKeys];
    
    for (NSString *index in sortedKeys) {
        
        NSMutableDictionary *value = [_actionsMap objectForKey:index];
        
        
        NSString *title = value[@"title"];
        GLAlertViewClickBlock clickBlock = value[@"block"];
        
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if ([title isEqualToString:kWDAlertViewCancelButtonDefaultTitle] ||
            [index intValue] == _cancelIndex)
        {
            style = UIAlertActionStyleCancel;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:style
                                                       handler:^(UIAlertAction *action) {
                                                           
                                                           if (clickBlock) {
                                                               clickBlock([index integerValue]);
                                                               kAlertViewTag = 0;
                                                               kAlertViewHasShow = NO;
                                                           }
                                                       }];
        
        
        [ac addAction:action];
    }
    
    
    return ac;
}
#endif


- (UIActionSheet *)prepareActionSheetForOlderiOS
{
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = _alertTitle;
//    as.title = nil;
    NSArray *sortedKeys = [self _sortedKeys];
    
    for (NSString *index in sortedKeys) {
        
        NSMutableDictionary *value = [_actionsMap objectForKey:index];
        NSString *title = value[@"title"];
        [as addButtonWithTitle:title];
        
        if ([title isEqualToString:kWDAlertViewCancelButtonDefaultTitle] ||
            [index intValue] == _cancelIndex) {
            as.cancelButtonIndex = [index integerValue];
        }
    }
    
    return as;
}

- (UIAlertView *)prepareAlertViewForOlderiOS
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title        = _alertTitle;
    alertView.message      = _alertMessage;
    alertView.delegate     = self;
    
    NSArray *sortedKeys = [self _sortedKeys];
    
    for (NSString *index in sortedKeys) {
        
        NSMutableDictionary *value = [_actionsMap objectForKey:index];
        NSString *title = value[@"title"];
        [alertView addButtonWithTitle:title];
    }
    
    
    return alertView;
}

- (NSArray *)_sortedKeys
{
    NSArray *sortedKeys = [[_actionsMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSInteger v1 = [obj1 integerValue];
        NSInteger v2 = [obj2 integerValue];
        if (v1 == v2) {
            return NSOrderedSame;
        }
        if (v1 < v2) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    return sortedKeys;
}

- (void)safeShow:(UIView *)iPadSourceView
{
    // 记录是否显示了alertview
    kAlertViewHasShow = YES;
    kAlertViewTag     = self.alertTag;
    
    //MARK: [Acorld] ---->自动添加取消按钮，默认最后一个，仅限于ActionSheet
    if (_style == GLAlertViewStyleActionSheet) {
        
        if (!_hadAddCancelButton) {
            
            self.cancelIndex = _actionsMap.count;
            [self addButtonWithIndex:_cancelIndex
                               title:kWDAlertViewCancelButtonDefaultTitle
                          clickBlock:NULL];
        }
        else {
            
            if (_cancelIndex == NSIntegerMin) {
                self.cancelIndex = _actionsMap.count;
            }
            [self addButtonWithIndex:_cancelIndex title:_cancelTitle
                          clickBlock:_cancelBlock];
            self.cancelTitle = nil;
            self.cancelBlock = NULL;
        }
    }
    
    if (!_useNSAlertView && GLUIKIT_IOS_VERSION > 7.9) {
#ifdef  __IPHONE_8_0
        UIAlertController * ac = [self prepareAlertViewForiOS8];
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        
        UIViewController *rootController = window.rootViewController;
        UIViewController *showingViewController = nil;
        
        if ([rootController isKindOfClass:[UINavigationController class]]) {
            
            showingViewController = ((UINavigationController *)rootController).topViewController;
        }
        else {
            
            showingViewController = rootController;
        }
        
        if (GLUIKIT_IS_IPHONE) {
            
            [showingViewController presentViewController:ac animated:YES completion:^{}];
        }
        else {
            
            //作兼容，如果没有传值，默认window
            if (!iPadSourceView)
            {
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                iPadSourceView = window;
            }
            
            UIPopoverPresentationController *ppc = [ac popoverPresentationController];
            ppc.sourceView = iPadSourceView;
            ppc.sourceRect = CGRectMake(iPadSourceView.frame.size.width / 2,
                                        iPadSourceView.frame.size.height, 0, 0);
            [showingViewController presentViewController:ac animated:YES completion:nil];
        }
        
#endif
        return;
    }
    kWDStrongSelf = self;
    
    
    switch (_style) {
            
            case GLAlertViewStyleActionSheet:
        {
            UIActionSheet *as = [self prepareActionSheetForOlderiOS];
            
            UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
            
            UIViewController *rootController = window.rootViewController;
            UIViewController *showingViewController = nil;
            
            if ([rootController isKindOfClass:[UINavigationController class]]) {
                showingViewController = ((UINavigationController *)rootController).topViewController;
            }
            else {
                showingViewController = rootController;
            }
            [as showInView:showingViewController.view];
            
        }
            break;
            
            case GLAlertViewStyleAlert:
        {
            UIAlertView *alertView = [self prepareAlertViewForOlderiOS];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
    
    //For iOS7，retain self
    _actionsMap[@"controller"] = self;
}


- (void)show:(UIView *)iPadSourceView
{
    if (![[NSThread currentThread] isMainThread]) {
        GL_WEAK(self);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weak_self safeShow:iPadSourceView];
        });
    } else {
        [self safeShow:iPadSourceView];
    }
}

- (void)show
{
    [self show:nil];
}

+ (BOOL)hasShow;
{
    return kAlertViewHasShow;
}

+ (NSUInteger)lastAlertTag;
{
    return kAlertViewTag;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    kAlertViewHasShow = NO;
    kAlertViewTag = 0;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *value = [_actionsMap objectForKey:[@(buttonIndex) stringValue]];
    
    if (value) {
        GLAlertViewClickBlock block = value[@"block"];
        if (block) {
            block(buttonIndex);
        }
    }
    
    kWDStrongSelf = nil;
    kAlertViewHasShow = NO;
    kAlertViewTag = 0;
    [_actionsMap removeAllObjects];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *value = [_actionsMap objectForKey:[@(buttonIndex) stringValue]];
    
    if (value) {
        
        GLAlertViewClickBlock block = value[@"block"];
        if (block) {
            block(buttonIndex);
        }
    }
    
    kWDStrongSelf = nil;
    kAlertViewHasShow = NO;
    kAlertViewTag = 0;
    
    [_actionsMap removeAllObjects];
}


@end

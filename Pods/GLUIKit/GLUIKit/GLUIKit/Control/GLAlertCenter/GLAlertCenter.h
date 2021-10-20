//
//  GLAlertCenter.h
//  GLUIKit
//
//  Created by smallsao on 2017/9/14.
//  Copyright © 2017年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLViewController.h"
#import "GLDIYAlertViewController.h"

typedef NS_OPTIONS (NSInteger, GLAlertCenterStyle) {
    GLAlertCenterStyleAlert,
    GLAlertCenterStyleActionSheet,
    GLAlertCenterStyleDIYAlert,
    GLAlertCenterStyleDIYActionSheet,
};

@interface GLAlertCenter : GLViewController

- (id)initWithStyle:(GLAlertCenterStyle)style title:(NSString *)title msg:(NSString *)msg;

/// GLAlertCenterStyleDIYAlert、GLAlertCenterStyleDIYActionSheet 使用， 添加自定义控件，在描述下方，按钮上方区域。宽度300，高度不限，居上8，居下28
- (void)add:(UIView *)content;

- (void)addButton:(NSString *)title clickBlock:(GLAlertCenterClickBlock)clickBlock;

- (void)addCancel:(NSString *)title clickBlock:(GLAlertCenterClickBlock)clickBlock;

// 仅GLAlertCenterStyleDIYActionSheet支持，按钮添加描述
- (void)addButton:(NSString *)title description:(NSString *)description clickBlock:(GLAlertCenterClickBlock)clickBlock;

- (void)show;

@end

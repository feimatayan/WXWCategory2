//
//  GLDIYAlertViewController.h
//  GLUIKit
//
//  Created by smallsao on 2021/7/20.
//

#import <UIKit/UIKit.h>

typedef void (^GLAlertCenterClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface GLDIYAlertViewController : UIViewController
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) UIView *vContent;
@property (nonatomic, strong) NSArray *actions;
@end

NS_ASSUME_NONNULL_END

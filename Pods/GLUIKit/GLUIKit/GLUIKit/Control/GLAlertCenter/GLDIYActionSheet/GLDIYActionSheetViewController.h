//
//  GLDIYActionSheetViewController.h
//  GLUIKit
//
//  Created by smallsao on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLDIYActionSheetViewController : UIViewController
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) UIView *vContent;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSDictionary *cancel;
@end

NS_ASSUME_NONNULL_END

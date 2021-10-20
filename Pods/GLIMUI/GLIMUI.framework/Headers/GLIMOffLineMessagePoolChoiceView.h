//
//  GLIMOffLineMessagePoolChoiceView.h
//  GLIMUI
//
//  Created by jiakun on 2020/3/5.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLIMOffLineMessagePoolChoiceViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLIMOffLineMessagePoolChoiceView : UIView

@property (nonatomic, copy) void (^itemClick)(int type, GLIMOffLineMessagePoolChoiceViewCellModel *model);

- (void)setDataWithType:(int)type list:(NSArray *)list subTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END

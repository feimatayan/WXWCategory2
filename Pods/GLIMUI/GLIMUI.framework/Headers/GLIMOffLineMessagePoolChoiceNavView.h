//
//  GLIMOffLineMessagePoolChoiceNavView.h
//  GLIMUI
//
//  Created by jiakun on 2020/3/5.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMOffLineMessagePoolChoiceNavView : UIView

@property (nonatomic, copy) void (^itemClick)(int type, int selected);

- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

- (void)updateDataWithType:(int)type title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END

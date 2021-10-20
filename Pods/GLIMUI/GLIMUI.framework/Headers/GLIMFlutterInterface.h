//
//  GLIMFlutterManager.h
//  GLIMUI
//
//  Created by jiakun on 2019/12/4.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLIMFlutterInterfaceDelegate <NSObject>

- (void)openFlutterPage:(NSString *)page
                 params:(id)params
                 result:(void (^)(id))result
                  modal:(BOOL)modal
               animated:(BOOL)animated;


@end

@interface GLIMFlutterInterface : NSObject

@property (nonatomic, weak) id<GLIMFlutterInterfaceDelegate> delegate;

+ (instancetype)sharedInstance;

+ (void)configWithDelegate:(NSObject<GLIMFlutterInterfaceDelegate> *)delegate;

+ (UINavigationController *)currentNavigationController;

- (void)openFlutterPage:(NSString *)page
                 params:(id)params
                 result:(void (^)(id))result
                  modal:(BOOL)modal
               animated:(BOOL)animated;

- (BOOL)openImNativePage:(NSString *)page
                  params:(NSDictionary *)params
          transitionType:(NSInteger)type;

- (void)flutterMethodCallHandlerMethod:(NSString *)method
                             arguments:(NSDictionary *)arguments
                                result:(void (^)(id))result;

@end

NS_ASSUME_NONNULL_END

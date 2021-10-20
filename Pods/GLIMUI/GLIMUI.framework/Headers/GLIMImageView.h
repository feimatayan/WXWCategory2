//
//  GLIMImageVIew.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
@interface GLIMImageView : UIImageView

@property (nonatomic,strong)NSString * imageUrl;

//若要使用点击重试功能 需传重试的image进来
@property (nonatomic,strong) UIImage * retryImage;
//不传则为retryImage的实际大小
@property (nonatomic,assign) CGSize retrySize;

//非聊天图片无需关心
//当前正在聊天的ID
@property (nonatomic,strong) NSString * pairedContactID;

//资源类型
@property (nonatomic) GLIMCacheResourceType resourceType;

@property (nonatomic, assign) GLIMChat* chat;

/**
 更新显示图片，用于本地的发送失败或待上传的图片

 @param image 图片
 */
- (void)updateImage:(UIImage *)image;

/**
 根据url设置图片
 
 @param url 图片url
 @param defultImage 默认显示图片
 */
- (void)setImageWithUrl:(NSString *)url defaultImage:(UIImage *)defultImage;


/**
 根据url设置高亮图片

 @param url 图片url
 @param defaultImage 默认显示图片
 */
- (void)setHighlightedImageWithUrl:(NSString *)url defaultImage:(UIImage *)defaultImage;

/**
 根据url设置图片
 
 @param url 图片url
 @param defaultImage 默认显示图片
 @param forceRefresh YES：强制刷新图片，NO：如果需要才刷新图片
 */
- (void)setImageWithUrl:(NSString *)url defaultImage:(UIImage *)defaultImage forceRefresh:(BOOL)forceRefresh;

- (void)getImageWithUrl:(NSString *)url defaultImage:(UIImage *)defultImage block:(void (^)(id result,NSError *error))callback;

- (void)cleanRetryImage;
+ (CGSize)getImageSizeWithUrl:(NSString *)urlStr;


+ (void)downloadImageWithUrl:(NSString *)url block:(void (^)(id result,NSError *error))callback;

@end

@interface GLIMImageView (GIF)

/**
 根据url设置图片
 
 @param url 图片url
 @param defaultImage 默认显示图片
 @param forceRefresh YES：强制刷新图片，NO：如果需要才刷新图片
 */
- (void)setGIFImageWithUrl:(NSString *)url
              defaultImage:(UIImage *)defaultImage
              forceRefresh:(BOOL)forceRefresh;

- (void)getGIFImageWithUrl:(NSString *)url
              defaultImage:(UIImage *)defaultImage
                     block:(void (^)(id result,NSError *error))callback;

@end

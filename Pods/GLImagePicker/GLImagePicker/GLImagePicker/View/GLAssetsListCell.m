//
//  GLAssetsCell.m
//  WDCommlib
//
//  Created by xiaofengzheng on 12/17/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//


//#define kTipWidth 50
//#define kTipHeight 45

#import "GLAssetsListCell.h"
#import "GLFetchImageAsset.h"
#import <GLUIKit/GLUIKit.h>
#import "GLCommonDef.h"
#import "GLFetchImageManager.h"

CGFloat     kELCAssetCellHeight;
NSInteger   kELCAssetCellColoumns;
NSInteger   kELCAssertWidth;
CGFloat     kELCAssertOffset;
CGFloat     kTipWidth;
CGFloat     kTipHeight;

@interface GLAssetsListCell () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *editImageViewArray;
@property (nonatomic, strong) NSMutableArray *overCheckArray;
@property (nonatomic, strong) NSMutableArray *overUncheckArray;
@property (nonatomic, strong) NSMutableArray *gifImageLogoViewArray;


@property (nonatomic, strong) GLFetchImageAsset *tempfetchImageAsset;

@property (nonatomic, strong) UIImageView       *tempOverCheckView;

@property (nonatomic, strong) UIImageView       *tempOverUncheckView;
@end

@implementation GLAssetsListCell

- (void)glSetup
{
    [super glSetup];
    // 隐藏分割线
    self.hideLineFlag = YES;
}

- (CGSize)targetSize
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(kELCAssertWidth * scale, kELCAssertWidth * scale);
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        if (GL_DEVICE_IPHONE_6) {
//            kELCAssetCellHeight = 92;
//            kELCAssertWidth = 85;
//            kELCAssetCellColoumns = 4;
//        } else if(GL_DEVICE_IPHONE_6_Plus || GL_DEVICE_IPHONE_6_Plus_Scale) {
//            kELCAssetCellHeight = 102;
//            kELCAssertWidth = 96;
//            kELCAssetCellColoumns = 4;
        if (GL_DEVICE_IPHONE_5 || GL_DEVICE_IPHONE_4) {
            kELCAssetCellHeight = 79;
            kELCAssertWidth = 75;
            kTipWidth = 50;
            kTipWidth = 45;
            kELCAssetCellColoumns = GLUIKIT_SCREEN_WIDTH / 80;
        } else {
            CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375.0;
            kELCAssetCellHeight = 92 * scale;
            kELCAssertWidth = 85 * scale;
            kTipWidth = 55;
            kTipHeight = 50;
            kELCAssetCellColoumns = 4;
        }
//        } else if (GL_DEVICE_IPHONE_X) {
//            kELCAssetCellHeight = 93;
//            kELCAssertWidth = 90;
//            kELCAssetCellColoumns = 4;
//        } else {
//            kELCAssetCellHeight = 79;
//            kELCAssertWidth = 75;
//            kELCAssetCellColoumns =  GLUIKIT_SCREEN_WIDTH / 80;
//        }
        
        kELCAssertOffset = (kELCAssetCellHeight - kELCAssertWidth)/2;
    });
}

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if(self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        self.overCheckArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.overUncheckArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        [self setAssets:assets];
    }
    return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
    // 重置
    for (UIImageView * iv in _imageViewArray) {
        iv.hidden = YES;
    }
    for (UIImageView * iv in _overUncheckArray) {
        iv.hidden = YES;
    }
    for (UIImageView * iv in _overCheckArray) {
        iv.hidden = YES;
    }
    
    if(assets.count == 0) {
        return;
    }
    
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overUncheck = nil;
    UIImage *overCheck = nil;
    
    for (int i = 0; i < [_rowAssets count]; ++i) {
        
        GLFetchImageAsset *fetchImageAsset = [_rowAssets objectAtIndex:i];
//        UIImageView *imageView = nil;
//        if (i < [_imageViewArray count]) {
//            imageView = [_imageViewArray objectAtIndex:i];
//        } else {
//            imageView = [[UIImageView alloc] init];
//            // zhengxf fix bug 2015-12-29
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            imageView.clipsToBounds = YES;
//            [_imageViewArray addObject:imageView];
//        }
//        imageView.hidden = NO;
        
        UIImageView *imageView = [self getImageView:_imageViewArray index:i];
        UIImageView *editImageView = [self getImageView:self.editImageViewArray index:i];
        editImageView.hidden = YES;
        if (fetchImageAsset.imageEditing) {
            editImageView.hidden = NO;
            editImageView.image = [UIImage imageNamed:@"GLPicker_edited_icon"];
        }
        
        if(self.showGif) {
            UIImageView *gifLogoImageview = [self getImageView:self.gifImageLogoViewArray index:i];
            if(fetchImageAsset.isGIF) {
                gifLogoImageview.hidden = NO;
                gifLogoImageview.image = [UIImage imageNamed:@"GLPicker_Gif_Logo"];
            } else {
                gifLogoImageview.hidden = YES;
                gifLogoImageview.image = nil;
            }
        }
        
        GL_WEAK(imageView);
        [[GLFetchImageManager sharedInstance] fetchImageWithAsset:fetchImageAsset targetSize:[self targetSize] completion:^(UIImage *image) {
            weak_imageView.image = image;
        } progress:^(double progress) {
            
        }];
        

        if (i < [_overCheckArray count]) {
            
            UIImageView *overCheckView = [_overCheckArray objectAtIndex:i];
            UIImageView *overUncheckView = [_overUncheckArray objectAtIndex:i];
            
            if (fetchImageAsset.isSelected) {
                overUncheckView.hidden = YES;
                overCheckView.hidden = NO;
            }else{
                overUncheckView.hidden = NO;
                overCheckView.hidden = YES;
            }
        } else {
            if (overCheck == nil) {
                overCheck = [UIImage imageNamed:@"GLPicker_select_image_check_small"];
                // [UIImage imageNamed:@"WDIPh_select_image_check_small"];
                overUncheck = [UIImage imageNamed:@"GLPicker_select_image_uncheck_small"];
                // [UIImage imageNamed:@"WDIPh_select_image_uncheck_small"];
            }
            
            UIImageView *overCheckView = [[UIImageView alloc] initWithImage:overCheck];
            UIImageView *overUncheckView = [[UIImageView alloc] initWithImage:overUncheck];
            
            [_overCheckArray addObject:overCheckView];
            [_overUncheckArray addObject:overUncheckView];
            
            if (fetchImageAsset.isSelected) {
                overUncheckView.hidden = YES;
                overCheckView.hidden = NO;
            } else {
                overUncheckView.hidden = NO;
                overCheckView.hidden = YES;
            }
        }
        
        
    }
}

// 创建图片视图
- (UIImageView *)getImageView:(NSMutableArray *)dataArray index:(NSInteger)i
{
    UIImageView *imageView = nil;
    if (i < [dataArray count]) {
        imageView = [dataArray objectAtIndex:i];
    } else {
        imageView = [[UIImageView alloc] init];
        // zhengxf fix bug 2015-12-29
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [dataArray addObject:imageView];
    }
    imageView.hidden = NO;
    return imageView;
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self];
    
    for (int i = 0; i < [_rowAssets count]; ++i) {
        
        CGRect frame = CGRectMake( 2*(i+1)*kELCAssertOffset + kELCAssertWidth*i, kELCAssertOffset, kELCAssertWidth, kELCAssertWidth);
        
        if (CGRectContainsPoint(frame, point)) {
            
            GLFetchImageAsset *fetchImageAsset = [_rowAssets objectAtIndex:i];
            
            CGRect tipRect = CGRectMake(CGRectGetMaxX(frame) - kTipWidth, frame.origin.y, kTipWidth, kTipHeight);
            
//            UIView *v = [[UIView alloc] init];
//            v.backgroundColor = [UIColor redColor];
//            v.frame = tipRect;
//            v.tag = 100;
//            [self addSubview:v];
            
            if(!CGRectContainsPoint(tipRect, point)){
                // 点击显示大图
                fetchImageAsset.clickType = GLFetchImageAssetClickTypePreview;
            } else {
                //
                fetchImageAsset.clickType = GLFetchImageAssetClickTypeSelect;
                if (self.clickCheckBlock) {
                    BOOL ret = self.clickCheckBlock(fetchImageAsset);
                    if (ret) {
                        fetchImageAsset.isSelected = !fetchImageAsset.isSelected;
                        UIImageView *overCheckView = [_overCheckArray objectAtIndex:i];
                        UIImageView *overUncheckView = [_overUncheckArray objectAtIndex:i];
                        
                        if (fetchImageAsset.isSelected && !fetchImageAsset.fullScreenImage) {
                            // 本次选中
                            BOOL isLocalFlag = [[GLFetchImageManager sharedInstance] checkImageIsInLocalAblumWithAsset:fetchImageAsset shouldShowGif:self.showGif];
                            if (!isLocalFlag) {
                                // 不在本地
                                self.tempfetchImageAsset = fetchImageAsset;
                                self.tempOverCheckView = overCheckView;
                                self.tempOverUncheckView = overUncheckView;
                                
                                NSString *message = @"你选择的是iCloud照片，同步速度较慢，确定添加?";
                                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                                             message:message
                                                                            delegate:self
                                                                   cancelButtonTitle:@"取消"
                                                                   otherButtonTitles:@"确定", nil];
                                [av show];
                                
                                return;
                            }
                        }
                        
                        if (fetchImageAsset.isSelected) {
                            overUncheckView.hidden = YES;
                            overCheckView.hidden = NO;
                        }else{
                            overUncheckView.hidden = NO;
                            overCheckView.hidden = YES;
                        }
                    } else {
                        // 超过最大选择个数
                        return;
                    }
                }
            }
            if (_clickAssetBlock) {
                _clickAssetBlock(fetchImageAsset);
            }
            break;
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 取消
        self.tempfetchImageAsset.isSelected = NO;
        

    } else if (buttonIndex == 1) {
        // 确定 DO 下载
        [[GLFetchImageManager sharedInstance] fetchPreviewImageWithAsset:self.tempfetchImageAsset completion:^(UIImage *previewImage) {
            
        } progress:^(double progress) {

        }];
    }
    if (self.tempfetchImageAsset.isSelected) {
        self.tempOverUncheckView.hidden = YES;
        self.tempOverCheckView.hidden = NO;
    }else{
        self.tempOverUncheckView.hidden = NO;
        self.tempOverCheckView.hidden = YES;
    }
    
    if (_clickAssetBlock) {
        _clickAssetBlock(self.tempfetchImageAsset);
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(2*kELCAssertOffset, kELCAssertOffset, kELCAssertWidth, kELCAssertWidth);
    CGFloat off = 5;
    CGFloat width = 24;
    
    CGFloat editImageViewW = 16;
    CGFloat editImageViewH = 12;
    CGFloat editImageViewY = 0;
    for (int i = 0; i < [_rowAssets count]; ++i) {
        
        UIImageView *imageView = [_imageViewArray objectAtIndex:i];
        imageView.frame = frame;
        [self addSubview:imageView];
        
        editImageViewY = CGRectGetMaxY(frame) - editImageViewH - off;
        UIImageView *editImageView = [self.editImageViewArray objectAtIndex:i];
        editImageView.frame = CGRectMake(CGRectGetMinX(frame)+off , editImageViewY, editImageViewW, editImageViewH);
        
        [editImageView removeFromSuperview];
        [self addSubview:editImageView];
        
        if (i < self.gifImageLogoViewArray.count) {
            UIImageView *gifLogoImageview = [self.gifImageLogoViewArray objectAtIndex:i];
            CGFloat gifLogoImvTop = CGRectGetMaxY(frame) - 12 - off;
            CGFloat gifLogoImvLeft = CGRectGetMinX(frame)+off;
            if(!editImageView.hidden) {
                gifLogoImvLeft += editImageView.width;
                gifLogoImvLeft += 5;
            }
            [gifLogoImageview removeFromSuperview];
            [self addSubview:gifLogoImageview];
            gifLogoImageview.frame = CGRectMake(gifLogoImvLeft, gifLogoImvTop, 22, 12);
        }

        
        UIImageView *overCheckView = [_overCheckArray objectAtIndex:i];
        UIImageView *overUncheckView = [_overUncheckArray objectAtIndex:i];
        overUncheckView.frame = overCheckView.frame = CGRectMake(CGRectGetMaxX(frame) - off - width , off, width, width);
        [self addSubview:overCheckView];
        [self addSubview:overUncheckView];
        
        frame.origin.x = frame.origin.x + frame.size.width + 2*kELCAssertOffset;
    }
    
//    UIView *v = [self viewWithTag:100];
//    [self bringSubviewToFront:v];
}

- (NSMutableArray *)editImageViewArray
{
    if (_editImageViewArray == nil) {
        _editImageViewArray = [NSMutableArray array];
    }
    return _editImageViewArray;
}

- (NSMutableArray *)gifImageLogoViewArray
{
    if (_gifImageLogoViewArray == nil) {
        _gifImageLogoViewArray = [NSMutableArray array];
    }
    return _gifImageLogoViewArray;
}
@end

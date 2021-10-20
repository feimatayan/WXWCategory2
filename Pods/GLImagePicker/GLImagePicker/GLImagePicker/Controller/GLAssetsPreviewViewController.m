//
//  GLAssetsPreviewViewController.m
//  WDCommlib
//
//  Created by xiaofengzheng on 12/17/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#define kMarginBottom 44


#import "GLAssetsPreviewViewController.h"
#import "GLFetchImageAsset.h"
#import <GLUIKit/GLUIKit.h>
#import "GLCommonDef.h"
#import "GLFetchImageManager.h"
#import <WDImageEditor/WDImageEditor.h>
#import "GLFetchImageConfig.h"

@interface GLAssetsPreviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,WDIEImageEditorDelegate>
{
    UIView *bottomView;
}
@property (nonatomic, strong) UICollectionView *collectionView;

///// 选择的Asset
@property (nonatomic, retain) NSMutableArray *editedAssetsArray;
/// 选择Button
@property (nonatomic, strong) UIButton *selectButton;

/// 完成Button
@property (nonatomic, strong) UIButton *finishButton;

/// 编辑按钮
@property (nonatomic, strong) UIButton *editButton;

/// 保存Nav颜色
@property (nonatomic, strong) UIColor *navColor;

@end

@implementation GLAssetsPreviewViewController
{
    BOOL isAfterLayout;
    
}


- (void)configNavigationBar
{
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 50, 30);
//    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setImage:[GLBundleUtils imageFromBundleWithName:@"GL_btn_navi_back"] forState:UIControlStateNormal];
//    
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:self.glLeftItem];
    
    // 设置 导航栏背景
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)glGoBack
{
    [super glGoBack];
    // 恢复 导航栏背景
    self.navigationController.navigationBar.barTintColor = self.navColor;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navColor = self.navigationController.navigationBar.barTintColor;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configNavigationBar];
    
    self.editedAssetsArray = [NSMutableArray new];
    
    if (!self.currentShowAsset.isSelected) {
        [self.editedAssetsArray addObject:self.currentShowAsset];
    }
    
    CGFloat bottomHeight = 0;
//    if (GL_DEVICE_IPHONE_X) {
//        bottomHeight =  34;
//    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        bottomHeight = mainWindow.safeAreaInsets.bottom;
    }
    
    CGRect rect = self.view.bounds;
    rect.size.height -= (kMarginBottom + bottomHeight);
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - kMarginBottom - bottomHeight, GLUIKIT_SCREEN_WIDTH, kMarginBottom)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, 100, kMarginBottom);
    [self.editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = FONTSYS(16);
    [bottomView addSubview:self.editButton];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishButton.frame = CGRectMake(GLUIKIT_SCREEN_WIDTH - 100, 0, 100, kMarginBottom);
    [self.finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton setTitleColor:UIColorFromRGB(0xc60a1e) forState:UIControlStateNormal];
    self.finishButton.titleLabel.font = FONTSYS(16);
    [bottomView addSubview:self.finishButton];
    
    
    [self updateButtonState];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!isAfterLayout) {
        isAfterLayout = YES;
        
        CGFloat bottomHeight = 0;
//        if (GL_DEVICE_IPHONE_X) {
//            bottomHeight =  34;
//        }
        if (@available(iOS 11.0, *)) {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            bottomHeight = mainWindow.safeAreaInsets.bottom;
        }
        
        CGRect rect = self.view.bounds;
        rect.size.height -= (kMarginBottom + bottomHeight);
        self.collectionView.frame = rect;
        [self.collectionView reloadData];
        
        
        NSInteger index = 0;
        if (self.previewType == GLAssetsPreviewSelected) {
            index = [self.assetsDataArray indexOfObject:self.currentShowAsset];
        } else {
            index = self.currentShowAsset.index;
        }
        _collectionView.contentOffset = CGPointMake(CGRectGetWidth(self.view.frame)*index, 0);
        
        bottomView.frame = CGRectMake(0, self.view.bounds.size.height - kMarginBottom - bottomHeight, GLUIKIT_SCREEN_WIDTH, kMarginBottom);
        self.editButton.hidden = self.showGif ? self.currentShowAsset.isGIF : NO;

    }
}

- (void)updateButtonState
{
    if (!self.selectButton) {
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake(0, 0, 28, 28);
        [self.selectButton addTarget:self action:@selector(selectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
    }
    
    if(self.currentShowAsset.isSelected){
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"GLPicker_select_image_check_big"] forState:UIControlStateNormal];
    }else{
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"GLPicker_select_image_uncheck_big"] forState:UIControlStateNormal];
    }
    
    
    
    if ([self.selectedAssetsArray count] > 0) {
        [self.finishButton setTitle:[NSString stringWithFormat:@"%zd/%zd 完成",[_selectedAssetsArray count],self.maxSelectedCount] forState:UIControlStateNormal];
    }else{
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}

#pragma mark - <WDIEImageEditorDelegate>

- (void)imageEditorDidCancel:(WDIEImageEditor *)imageEditor
{
    [imageEditor dismissViewControllerAnimated:NO completion:nil];
}

- (void)imageEditor:(WDIEImageEditor *)imageEditor finishWithImage:(UIImage *)image
{
    [self imageEditorDidCancel:imageEditor];
    self.currentShowAsset.imageEditing = image;
    [self.editedAssetsArray addObject:self.currentShowAsset];
//    if ([self.assetsDataArray containsObject:self.currentShowAsset]) {
        self.currentShowAsset.imageEditing = image;
//    }
    [self.collectionView reloadData];
}

#pragma mark - Events

- (void)editButtonAction
{
	UIImage *image = self.currentShowAsset.imageEditing ?: self.currentShowAsset.fullScreenImage;
    
    WDIEImageEditor *editorVc = [[WDIEImageEditor alloc] initWithImage:image];
    editorVc.delegate = self;
    [self.navigationController presentViewController:editorVc animated:NO completion:nil];
}

- (void)finishButtonAction
{
    if (self.selectedAssetsArray.count == 0) {
        [self selectButtonAction];
    }
    
    if (self.clickFinishBlock) {
        self.clickFinishBlock();
    }
}

- (void)selectButtonAction
{
    if (self.clickCheckBlock) {
        BOOL ret = self.clickCheckBlock(self.currentShowAsset);
        if (ret) {
            
            self.currentShowAsset.isSelected = !self.currentShowAsset.isSelected;
            if (self.currentShowAsset.isSelected) {
                if (![self.selectedAssetsArray containsObject:self.currentShowAsset]) {
                    [self.selectedAssetsArray addObject:self.currentShowAsset];
                }
            } else {
                if ([self.selectedAssetsArray containsObject:self.currentShowAsset]) {
                    [self.selectedAssetsArray removeObject:self.currentShowAsset];
                }
            }
            
            if (self.clickSelectBlock) {
                self.clickSelectBlock();
            }
            
            [self updateButtonState];
        }
    }
}


#pragma mark --

#define kGLPinchableImageView 100

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!isAfterLayout) {
        return 0;
    }
    
    return [self totalCount];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return collectionView.frame.size;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    GLPinchableImageView *imgView = (GLPinchableImageView *)[cell viewWithTag:kGLPinchableImageView];
    if (!imgView) {
        CGRect rect = cell.bounds;
        imgView = [[GLPinchableImageView alloc] initWithFrame:rect];
        imgView.tag = kGLPinchableImageView;
        [cell addSubview:imgView];
    }
    [imgView hideProgressView];
    
    
    if (indexPath.item < [self totalCount]) {
        GLFetchImageAsset *fetchImageAsset = [self fectchImageAsset:indexPath.item];
//        if(self.currentPage == indexPath.item && self.currentShowAsset){
//            fetchImageAsset = self.currentShowAsset;
//        }
        imgView.viewIdentifier = fetchImageAsset;
        
        [[GLFetchImageManager sharedInstance] fetchPreviewImageWithAsset:fetchImageAsset fetchGif:self.showGif completion:^(UIImage *previewImage) {
			if (fetchImageAsset == imgView.viewIdentifier) {
                if (fetchImageAsset.imageEditing) {
                    imgView.image = fetchImageAsset.imageEditing;
                } else {
                    imgView.image = previewImage;
                }
			}
		} progress:^(double progress) {
			if (fetchImageAsset == imgView.viewIdentifier) {
				[imgView showProgressView:progress];
			}
		}];
    }
    
    return cell;
}

- (NSInteger) totalCount {
    if (self.previewType == GLAssetsPreviewSelected) {
        return [self.assetsDataArray count];
    } else {
        return self.originFetchResult.count;
    }
}

- (GLFetchImageAsset *) fectchImageAsset:(NSInteger) index {
    if (self.previewType == GLAssetsPreviewSelected) {
        return [self.assetsDataArray objectAtIndex:index];
    } else {
        GLFetchImageAsset * gLAsset = [self getGLAssetFromSelectedAssets:index];
        if (gLAsset==nil) {
            gLAsset = [self getGLAssetFromEditedAssets:index];
        }
        if (gLAsset == nil) {
            PHAsset *phAsset = [self.originFetchResult objectAtIndex:(index)];
            gLAsset = [GLFetchImageAsset getFetchImageAsseWithPHAsset:phAsset];
            gLAsset.data = phAsset;
            gLAsset.index = index;
        }
        
        return gLAsset;
    }
}

- (GLFetchImageAsset *)getGLAssetFromSelectedAssets:(NSInteger)index {
    for (GLFetchImageAsset *gLimageAsset in self.selectedAssetsArray) {
        if (gLimageAsset.index == index) {
            return gLimageAsset;
        }
    }
    return nil;
    
}

- (GLFetchImageAsset *)getGLAssetFromEditedAssets:(NSInteger)index {
    for (GLFetchImageAsset *gLimageAsset in self.editedAssetsArray) {
        if (gLimageAsset.index == index) {
            return gLimageAsset;
        }
    }
    return nil;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    if ([scrollView isKindOfClass:[UICollectionView class]] && currentPage < [self totalCount]) {
        UICollectionView *cv = (UICollectionView *)scrollView;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
        UICollectionViewCell *cell = [cv cellForItemAtIndexPath:indexPath];
        if (cell) {
            GLPinchableImageView *imgView = (GLPinchableImageView *)[cell viewWithTag:kGLPinchableImageView];
            if (imgView) {
                self.currentShowAsset = imgView.viewIdentifier;
            }
        }
    }
    
    [self updateButtonState];
}

- (void)setCurrentShowAsset:(GLFetchImageAsset *)currentShowAsset
{
    _currentShowAsset = currentShowAsset;
    self.editButton.hidden = self.showGif ? self.currentShowAsset.isGIF : NO;
}

@end

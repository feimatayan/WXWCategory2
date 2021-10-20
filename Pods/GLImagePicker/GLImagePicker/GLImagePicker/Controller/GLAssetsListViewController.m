//
//  GLAssetsViewController.m
//  WDCommlib
//
//  Created by xiaofengzheng on 12/16/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//

#define kMarginBottom 44

#define TAG_PROGRESS_VIEW_BKView    54000
#define TAG_PROGRESS_VIEW_LABEL     54001


#define kWidth_progressView         234
#define kHeight_progressView        50
#define kLeftMargin_textLabel       15
#define kRightMargin_textLabel      27
#define kBorder_closeButton         34
#define kRightMargin_closeButton    5



#import "GLAssetsListViewController.h"
#import "GLAssetsPreviewViewController.h"
#import "GLAssetsListCell.h"
#import "GLFetchImageAsset.h"
#import <GLUIKit/GLUIKit.h>
#import "GLCommonDef.h"
#import "GLFetchImageManager.h"
#import "GLFetchImageGroup.h"
#import "GLFetchImageConfig.h"

#import "GLLimitedStatusView.h"

#import <Photos/Photos.h>

#import "GLIPUTUtil.h"

#define limited_status_viewHeight 53.0

@interface GLAssetsListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    GLButton        *_finishButton;
    GLButton        *_previewButton;
}
// Limited权限提示
@property (nonatomic, assign) BOOL isLimitedStatus;

@property (nonatomic, retain) GLLimitedStatusView *limitedStatusView;


/// 照片列表
@property (nonatomic, retain) GLTableView       *tableView;
/// data
//@property (nonatomic, retain) NSMutableArray    *assetsArray;

// 系统返回相册
@property (nonatomic, retain) PHFetchResult *originFetchResult;
///
@property (nonatomic, retain) NSMutableArray    *selectedAssetsArray;
//@property (nonatomic, retain) NSMutableDictionary    *selectedAssetsDict;


@property (nonatomic, strong) GLView            *loadingView;
/// 图片上传进度
@property (nonatomic, strong) NSString          *currentProgressStr;

@property (nonatomic, retain) UIView *bottomView;

@property (nonatomic, assign) CGFloat bottomHeight;

@end

@implementation GLAssetsListViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
   return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KFetchPreviewImageSuccessNotification object:nil];
}


- (void)configNavigationBar
{
    
    UILabel *label        = [[UILabel alloc] initWithFrame:CGRectZero];
    label.frame           = CGRectMake((GLUIKIT_SCREEN_WIDTH - 160) / 2, 0, 160, 44);
    label.font            = [UIFont boldSystemFontOfSize:20.0];
    label.textColor       = [UIColor whiteColor];
    label.textAlignment   = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text            = _currentGroup.name;
    self.navigationItem.titleView = label;
    
    
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 50, 30);
//    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setImage:[GLBundleUtils imageFromBundleWithName:@"GL_btn_navi_back"] forState:UIControlStateNormal];
//    // [UIImage imageNamed:@"WDIPh_btn_navi_back"]
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:self.glLeftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 50, 30);
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
}


//- (void)leftButtonAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)rightButtonAction:(id)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (GLFetchImageConfig *)config {
	if (!_config) {
		_config = [GLFetchImageConfig new];
	}
	
	return _config;
}

- (void)checkAuthority {
    if ([PHPhotoLibrary respondsToSelector:@selector(authorizationStatusForAccessLevel:)]) {
        PHAuthorizationStatus status = [PHPhotoLibrary performSelector:@selector(authorizationStatusForAccessLevel:) withObject:@(2)];
        if (status == 4) {
            self.isLimitedStatus = YES;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self configViews];
    [self showLoadingToast];
    
//    self.assetsArray = [[NSMutableArray alloc] init];
    self.selectedAssetsArray = [[NSMutableArray alloc] init];
//    self.selectedAssetsDict = [NSMutableDictionary new];
    
    [self performSelector:@selector(startPreparePhotos) withObject:nil afterDelay:0.1];
    
}

- (void)startPreparePhotos {
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    
    [GLIPUTUtil commitTechEvent:@"GLAssetsListViewController"
                           arg1:@"startPreparePhotos"
                           arg2:@"enter"
                           arg3:@""
                           args:@{@"module":@"GLImagePicker", @"startTime":@(startTime)}];
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.assetsArray.count) {
    if (self.originFetchResult.count) {
        [self.tableView reloadData];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self hideLoadingToast];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// 设置界面元素
- (void)configViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.bottomHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        self.bottomHeight = mainWindow.safeAreaInsets.bottom;
    }

    // Limited权限提示
    if (!self.limitedStatusView) {
        CGRect frameOfLimitedView = CGRectZero;
        frameOfLimitedView.origin.x = 0;
        frameOfLimitedView.origin.y = 0;
        frameOfLimitedView.size.width = GLUIKIT_SCREEN_WIDTH;
        frameOfLimitedView.size.height = limited_status_viewHeight;
        self.limitedStatusView = [[GLLimitedStatusView alloc] initWithFrame:frameOfLimitedView];
        self.limitedStatusView.hidden = YES;
        self.limitedStatusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.limitedStatusView];
    }
    
    // 照片列表
    if (!self.tableView) {
        self.tableView = [[GLTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _tableView.
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - kMarginBottom - self.bottomHeight);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:self.tableView];
    }

    // 底部工具栏
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - kMarginBottom - self.bottomHeight, GLUIKIT_SCREEN_WIDTH, kMarginBottom + self.bottomHeight)];
    bottomView.backgroundColor = UIColorFromRGB(0xe8eaea);
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    // 完成 按钮
    _finishButton = [GLButton buttonWithType:UIButtonTypeCustom];
    _finishButton.frame = CGRectMake(GLUIKIT_SCREEN_WIDTH - 100, 0, 100, kMarginBottom);
    [_finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_finishButton setTitleColor:UIColorFromRGB(0xc60a1e) forState:UIControlStateNormal];
    [_finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _finishButton.titleLabel.font = FONTSYS(16);
    [bottomView addSubview:_finishButton];
    
    // 预览按钮
    _previewButton = [GLButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(0, 0, 90, kMarginBottom);
    [_previewButton addTarget:self action:@selector(previewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitleColor:UIColorFromRGB(0xc60a1e) forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.titleLabel.font = FONTSYS(16);
    [bottomView addSubview:_previewButton];
}

- (void) adjustViews {
    [self checkAuthority];
    
    if (self.isLimitedStatus) {
        CGRect frameOfTableView = CGRectMake(0, limited_status_viewHeight, self.view.width, self.view.height - kMarginBottom - self.bottomHeight);
        frameOfTableView.size.height = self.view.height - kMarginBottom - self.bottomHeight - limited_status_viewHeight;
        self.tableView.frame = frameOfTableView;
        
        self.limitedStatusView.hidden = NO;
    } else {
        self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - kMarginBottom - self.bottomHeight);
        if (self.limitedStatusView) {
            self.limitedStatusView.hidden = YES;
        }
    }
}


#pragma mark-- 完成
- (void)finishButtonAction
{
    if ([self checkTotalProgress]) {
        [self fetchImageFinished];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoadingProgress) name:KFetchPreviewImageSuccessNotification object:nil];
        [self showLoading:YES];
    }
}


- (void)fetchImageFinished
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KFetchPreviewImageSuccessNotification object:nil];
    if (self.finishBlock) {
        for (GLFetchImageAsset *imageAsset in self.selectedAssetsArray) {
            if (imageAsset.imageEditing) { // 替换fullScreenImage
                imageAsset.fullScreenImage = imageAsset.imageEditing;
            }
        }
        // 完成
        self.finishBlock(self.selectedAssetsArray);
    }
}

- (BOOL)checkTotalProgress
{
    BOOL ret = YES;
    if (GL_SYSTEM_IOS8 && _selectedAssetsArray.count > 0) {
        CGFloat totalProgress = 0;
        for (int i = 0; i < _selectedAssetsArray.count; i++) {
            GLFetchImageAsset *fetchImageAsset = [_selectedAssetsArray objectAtIndex:i];
            totalProgress += fetchImageAsset.progress;
        }
        
        CGFloat currentProgress = totalProgress/_selectedAssetsArray.count;
        if (currentProgress < 0.01) {
            currentProgress = 0.01;
        }
        
        self.currentProgressStr = [NSString stringWithFormat:@"%zd%%",(NSInteger)(currentProgress * 100)];
        
        if ([self.currentProgressStr isEqualToString:@"100%"]) {
            ret = YES;
        } else {
            ret = NO;
        }
    }
    return ret;
}

- (void)updateLoadingProgress
{
    if (self.loadingView && !self.loadingView.hidden) {
        if ([self checkTotalProgress]) {
            [self fetchImageFinished];
        } else {
            [self showLoading:YES];
        }
    }
}

- (void)loadingViewCloseButtonAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KFetchPreviewImageSuccessNotification object:nil];
    [self showLoading:NO];
}


- (void)showLoading:(BOOL)loadingFlag
{
    
    if (!_loadingView) {
        GLView *loadingBKView = [[GLView alloc] initWithFrame:self.view.bounds];
        loadingBKView.backgroundColor = [UIColor clearColor];
        loadingBKView.tag = TAG_PROGRESS_VIEW_BKView;
        [self.view addSubview:loadingBKView];
        
        
        GLView *progressView = [[GLView alloc] initWithFrame:CGRectMake((loadingBKView.width - kWidth_progressView)/2,
                                                                        (loadingBKView.height - kHeight_progressView)/2,
                                                                        kWidth_progressView,
                                                                        kHeight_progressView)];
        progressView.layer.borderWidth   = GL_HEIGHT_LINE;
        progressView.layer.borderColor   = [UIColor clearColor].CGColor;
        progressView.layer.cornerRadius  = 5.0f;
        progressView.layer.masksToBounds = YES;
        progressView.alpha = 0.75;
        progressView.backgroundColor = [UIColor blackColor];
        [loadingBKView addSubview:progressView];
        
        
        
        GLLabel *textLabel = [[GLLabel alloc] initWithFrame:CGRectMake(kLeftMargin_textLabel,
                                                                       0,
                                                                       progressView.width - kLeftMargin_textLabel - kRightMargin_textLabel,
                                                                       progressView.height)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag  = TAG_PROGRESS_VIEW_LABEL;
        textLabel.font = FONTSYS(15);
        textLabel.textColor = [UIColor whiteColor];
        [progressView addSubview:textLabel];
        
        
        GLButton *closeButton = [GLButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"GLPicker_toast_close"] forState:UIControlStateNormal];
        closeButton.frame = CGRectMake(progressView.width - kRightMargin_closeButton - kBorder_closeButton,
                                       (progressView.height - kBorder_closeButton)/2,
                                       kBorder_closeButton,
                                       kBorder_closeButton);
        [closeButton addTarget:self action:@selector(loadingViewCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [progressView addSubview:closeButton];
        
        
        self.loadingView = loadingBKView;
    }
    
    
    if (loadingFlag) {
        GLView *bkView = [self.loadingView viewWithTag:TAG_PROGRESS_VIEW_BKView];
        GLLabel *titleLabel = [bkView viewWithTag:TAG_PROGRESS_VIEW_LABEL];
        if (titleLabel) {
            titleLabel.text = [NSString stringWithFormat:@"iCloud照片同步中(%@)...",self.currentProgressStr];
        }
        self.loadingView.hidden = NO;
        
    } else {
        self.loadingView.hidden = YES;
    }
}


/// 预览选中的图片
- (void)previewButtonAction
{
    if (self.selectedAssetsArray.count > 0) {
//        [self previewWithAsset:[_selectedAssetsArray firstObject] dataArray:_selectedAssetsDict];
        [self previewType:GLAssetsPreviewSelected withAsset:[self.selectedAssetsArray firstObject]];
    }
}

#pragma mark -- private
- (void)preparePhotos
{
    GL_WEAK(self);
//    if (self.currentGroup) {
//        [[GLFetchImageManager sharedInstance] fetchImageAssetArrayHasVideo:NO group:self.currentGroup completion:^(NSArray<GLFetchImageAsset *> *imageAssetArray) {
//            [weak_self.assetsArray addObjectsFromArray:imageAssetArray];
//
//
//        }];
//    }
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    
    [GLIPUTUtil commitTechEvent:@"GLAssetsListViewController"
                           arg1:@"preparePhotos"
                           arg2:@"s1"
                           arg3:@""
                           args:@{@"module":@"GLImagePicker", @"startTime":@(startTime)}];

    if (self.currentGroup && self.currentGroup.data) {
        
        self.originFetchResult = self.currentGroup.data;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [GLIPUTUtil commitTechEvent:@"GLAssetsListViewController"
                                   arg1:@"preparePhotos"
                                   arg2:@"s3"
                                   arg3:@""
                                   args:@{@"module":@"GLImagePicker"}];
            
            [weak_self adjustViews];
            [weak_self.tableView reloadData];
            // scroll to bottom
            NSInteger section = [weak_self numberOfSectionsInTableView:weak_self.tableView] - 1;
            NSInteger row = [weak_self tableView:weak_self.tableView numberOfRowsInSection:section] - 1;
            if (section >= 0 && row >= 0) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:section];
                [weak_self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            [weak_self updateChooseState];
            
            [GLIPUTUtil commitTechEvent:@"GLAssetsListViewController"
                                   arg1:@"preparePhotos"
                                   arg2:@"s4"
                                   arg3:@""
                                   args:@{@"module":@"GLImagePicker"}];
        });
    }
    
    startTime = [[NSDate date] timeIntervalSince1970];
    
    [GLIPUTUtil commitTechEvent:@"GLAssetsListViewController"
                           arg1:@"preparePhotos"
                           arg2:@"s2"
                           arg3:@"end"
                           args:@{@"module":@"GLImagePicker", @"startTime":@(startTime)}];
}

- (void)updateChooseState
{
    
    NSInteger currentCount = [self.selectedAssetsArray count];
    if (currentCount > 0) {
        [_finishButton setTitle:[NSString stringWithFormat:@"%zd/%zd 完成",currentCount,_maxSelectedCount] forState:UIControlStateNormal];
    } else {
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    if (currentCount > 0) {
        _finishButton.enabled = YES;
        _previewButton.enabled = YES;
    } else {
        _finishButton.enabled = NO;
        _previewButton.enabled = NO;
    }
}


/**
 选择前的一些验证，例:图片大小验证

 @param asset 图片Asset
 @return YES:通过 NO:未通过
 */
- (BOOL)validateImageAsset:(GLFetchImageAsset *)asset
{
	if (!self.showGif) {
		return YES;
	}
	
	if (!asset) {
		return NO;
	}
	
	if (asset.isGIF && !asset.gifData) {
		[[GLFetchImageManager sharedInstance] checkImageIsInLocalAblumWithAsset:asset shouldShowGif:YES];
	}
	
	if (asset.isGIF && asset.gifData.length > self.config.gifLimitSize) {
		
		NSString *msg = [NSString stringWithFormat:@"gif图不能超过%ziM",(long)(self.config.gifLimitSize / 1024 / 1024)];
		
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
		[alert addAction:cancel];
		
		[self presentViewController:alert animated:YES completion:nil];
		
		return NO;
	}
	
	return YES;
}


#pragma mark- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.originFetchResult.count / (float)kELCAssetCellColoumns);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kELCAssetCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GLAssetsListCell";
    
    GLAssetsListCell *cell = (GLAssetsListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[GLAssetsListCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 记录下cell的行数，再点击的时候根据行数计算出cell的index
        cell.tag = indexPath.row;
        
        GL_WEAK(self);
        cell.clickAssetBlock = ^(GLFetchImageAsset *asset){
            
            switch (asset.clickType) {
                case GLFetchImageAssetClickTypeSelect: {
                    // 选择
                    if (asset.isSelected) {
                        if (![weak_self.selectedAssetsArray containsObject:asset]) {
                            [weak_self.selectedAssetsArray addObject:asset];
                        }
                        
//                        if ([weak_self.selectedAssetsDict objectForKey:@(asset.index)] == nil) {
//                            [weak_self.selectedAssetsDict setObject:asset forKey:@(asset.index)];
//                        }
                    } else if ([weak_self.selectedAssetsArray containsObject:asset]) {
//                    } else if ([weak_self.selectedAssetsDict objectForKey:@(asset.index)] != nil) {
                    
                            [weak_self.selectedAssetsArray removeObject:asset];
                    }
                    
                    [weak_self updateChooseState];
                    
                    break;
                }
                case GLFetchImageAssetClickTypePreview: {
                    // 预览所有图片
//                    [weak_self previewWithAsset:asset dataArray:weak_self.selectedAssetsDict];
                    [weak_self previewType:GLAssetsPreviewAll withAsset:asset];
                    break;
                }
                    
                default:
                    break;
            }
        };
        cell.clickCheckBlock = ^BOOL(GLFetchImageAsset *asset) {
            return [weak_self checkMaxCount:asset] && [weak_self validateImageAsset:asset];
        };
    }
    
    cell.showGif = self.showGif;
    [cell setAssets:[self assetsForIndexPath:indexPath]];

    return cell;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    NSInteger index = path.row * kELCAssetCellColoumns;
    NSInteger length = MIN(kELCAssetCellColoumns, self.originFetchResult.count - index);
    if(index < self.originFetchResult.count && index + length - 1 < self.originFetchResult.count) {
        NSMutableArray *resltArray = [NSMutableArray new];
        for (int i=0; i<length; i++) {
            GLFetchImageAsset * gLAsset = [self getGLAssetFromSelectedAssets:(index +i)];
            if (gLAsset == nil) {
                PHAsset *phAsset = [self.originFetchResult objectAtIndex:(index+i)];
                gLAsset = [GLFetchImageAsset getFetchImageAsseWithPHAsset:phAsset];
                gLAsset.data = phAsset;
                gLAsset.index = index + i;
            }
            [resltArray addObject:gLAsset];
        }
        return resltArray;
    }
    return @[];
}

- (GLFetchImageAsset *)getGLAssetFromSelectedAssets:(NSInteger)index {
    for (GLFetchImageAsset *gLimageAsset in self.selectedAssetsArray) {
        if (gLimageAsset.index == index) {
            return gLimageAsset;
        }
    }
    return nil;
    
}

//- (void)previewWithAsset:(GLFetchImageAsset *)asset dataArray:(NSDictionary *)array
//{
//    GL_WEAK(self);
//    GLAssetsPreviewViewController *assetsPreviewViewController = [[GLAssetsPreviewViewController alloc] init];
//    assetsPreviewViewController.maxSelectedCount = self.maxSelectedCount;
//    assetsPreviewViewController.currentShowAsset = asset;
//    assetsPreviewViewController.assetsDataArray = array;
//    assetsPreviewViewController.selectAssetsArray = self.selectedAssetsArray;
//    assetsPreviewViewController.showGif = self.showGif;
//    assetsPreviewViewController.clickSelectBlock = ^ {
//        [weak_self updateChooseState];
//        [weak_self.tableView reloadData];
//    };
//    assetsPreviewViewController.clickFinishBlock = ^ {
//        [weak_self finishButtonAction];
//    };
//    assetsPreviewViewController.clickCheckBlock = ^BOOL(GLFetchImageAsset *asset) {
//		return [weak_self checkMaxCount:asset] && [weak_self validateImageAsset:asset];
//    };
//    [self.navigationController pushViewController:assetsPreviewViewController animated:YES];
//
//}


- (void)previewType:(GLAssetsPreviewType)previewType withAsset:(GLFetchImageAsset *)asset {
    GL_WEAK(self);
    GLAssetsPreviewViewController *assetsPreviewViewController = [[GLAssetsPreviewViewController alloc] init];
    assetsPreviewViewController.maxSelectedCount = self.maxSelectedCount;
    assetsPreviewViewController.currentShowAsset = asset;
    assetsPreviewViewController.originFetchResult = self.originFetchResult;
    assetsPreviewViewController.assetsDataArray = self.selectedAssetsArray;
    assetsPreviewViewController.selectedAssetsArray = self.selectedAssetsArray;
    assetsPreviewViewController.previewType = previewType;
    assetsPreviewViewController.showGif = self.showGif;
    assetsPreviewViewController.clickSelectBlock = ^ {
        [weak_self updateChooseState];
        [weak_self.tableView reloadData];
    };
    assetsPreviewViewController.clickFinishBlock = ^ {
        [weak_self finishButtonAction];
    };
    assetsPreviewViewController.clickCheckBlock = ^BOOL(GLFetchImageAsset *asset) {
        return [weak_self checkMaxCount:asset] && [weak_self validateImageAsset:asset];
    };
    [self.navigationController pushViewController:assetsPreviewViewController animated:YES];
}

- (BOOL)checkMaxCount:(GLFetchImageAsset *)asset
{
    BOOL ret = YES;
    NSInteger count = _selectedAssetsArray.count;
    if (asset.isSelected == NO) {
        count++;
    }
    if (count > self.maxSelectedCount) {
        // WDLocalizedString(@"WDSTR_ZDZNXZ_VAR_ZTP") WDLocalizedString(@"WDSTR_WZDL")
		// 防止小于0的情况
		NSString *tip = self.maxSelectedCount <= 0 ? @"你使用的图片已超过最大数目，请检查后重试！" : [NSString stringWithFormat:@"你最多只能选%zd张", self.maxSelectedCount];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tip
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return ret;
}


@end

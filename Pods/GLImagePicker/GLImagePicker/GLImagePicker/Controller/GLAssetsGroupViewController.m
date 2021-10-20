//
//  GLAssetsGroupViewController.m
//  WDCommlib
//
//  Created by xiaofengzheng on 12/16/15.
//  Copyright © 2015 赵 一山. All rights reserved.
//


#import "GLAssetsGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+GLAssetsLibrary.h"
#import "GLAssetsListViewController.h"
#import <GLUIKit/GLUIKit.h>
#import "GLFetchImageManager.h"
#import "GLFetchImageGroup.h"
#import "GLAssetsGroupCell.h"
#import "GLCommonDef.h"
#import "GLFetchImageConfig.h"

#import "GLIPUTUtil.h"
#import "GLImageGroupManager.h"
#import "GLLimitedStatusView.h"


#define limited_status_viewHeight 53.0

@interface GLAssetsGroupViewController ()<UITableViewDataSource,UITableViewDelegate,PHPhotoLibraryChangeObserver>


/// tableView
@property (nonatomic, retain) GLTableView   *tableView;
///
@property (nonatomic, retain) NSMutableArray       *groupArray;

/// 当前的组
@property (nonatomic, retain) GLFetchImageGroup     *currentGroup;

// Limited权限提示
@property (nonatomic, assign) BOOL isLimitedStatus;

@property (nonatomic, retain) GLLimitedStatusView *limitedStatusView;

@end

@implementation GLAssetsGroupViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
   return UIStatusBarStyleLightContent;
}

- (GLFetchImageConfig *)config {
	if (!_config) {
		_config = [GLFetchImageConfig new];
	}
	
	return _config;
}

-(void)dealloc {
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
}

- (void)configNavigationBar
{
    // title
    UILabel *titleLabel             = [[UILabel alloc] init];
    titleLabel.frame                = CGRectMake((GLUIKIT_SCREEN_WIDTH - 160) / 2, 0, 160, 44);
    titleLabel.font                 = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.text                 = @"选择相册";// WDLocalizedString(@"WDSTR_XZTX");
    titleLabel.textColor            = [UIColor whiteColor];
    titleLabel.textAlignment        = NSTextAlignmentCenter;
    titleLabel.backgroundColor      = [UIColor clearColor];
    self.navigationItem.titleView   = titleLabel;
    
    // right
    UIButton *rightButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame       = CGRectMake(0, 0, 50, 30);
    // WDLocalizedString(@"WD_COM_CANCEL")
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightButton addTarget:self
                    action:@selector(rightButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    
}

- (void)configViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    
    if (!self.tableView) {
        self.tableView = [[GLTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _tableView.
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.frame = self.view.bounds;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
}


- (void)rightButtonAction:(id)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self configViews];
    [self showLoadingToast];
    
    [self registPhotoChangeObserver];
    
    [self prepareData];

    [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                           arg1:@"viewDidLoad"
                           arg2:@"end"
                           arg3:@""
                           args:@{@"module":@"GLImagePicker"}];
}

- (void)registPhotoChangeObserver {
    GL_WEAK(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:weak_self];
            }
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.groupArray.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)initData {
    self.groupArray = [GLImageGroupManager sharedInstance].collectionGroupArray;
}

- (void)showTips
{
    GLAlertView *alertView = [[GLAlertView alloc] initWithTitle:@"打开相册失败"
                                                        message:@"请在设置->隐私->照片选项中\n设置允许微店访问你的相册。"
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)prepareData
{
    if ([self isViewLoaded]) {
        // 加载数据
        GL_WEAK(self);
        [GLFetchImageManager requestAuthorization:^(GLFetchImageAuthorizationStatus status) {
            if (status == GLFetchImageAuthorizationStatusDenied ||
                status == GLFetchImageAuthorizationStatusRestricted) {
                [weak_self hideLoadingToast];
                [weak_self showTips];
            } else {
                [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                       arg1:@"prepareData"
                                       arg2:@"s1"
                                       arg3:@""
                                       args:@{@"module":@"GLImagePicker"}];
                
                [weak_self adjustViews];
                
                // ~~ 分阶段获取图片开始
                // ~~ 获取最近项目 Recents 相册
                if (self.groupArray.count == 0 || [GLImageGroupManager sharedInstance].freshComplete) {
                    
//                    [[GLImageGroupManager sharedInstance].collectionGroupArray removeAllObjects];
                    [GLImageGroupManager sharedInstance].freshComplete = NO;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                               arg1:@"prepareData"
                                               arg2:@"start-fetch-group"
                                               arg3:@""
                                               args:@{@"module":@"GLImagePicker"}];
                        
                        [[GLFetchImageManager sharedInstance] fetchImageGroupHasVideo:NO
                                                                        withFetchType:GLFetchImageTypeRecents
                                                                           completion:^(NSArray<GLFetchImageGroup *> *groupArray, BOOL complete) {
                            [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                                   arg1:@"prepareData"
                                                   arg2:@"s2-fetchgroup-ok"
                                                   arg3:@""
                                                   args:@{@"module":@"GLImagePicker",@"groupcount":@(groupArray.count)}];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                                       arg1:@"prepareData"
                                                       arg2:@"s3-main-queue"
                                                       arg3:@""
                                                       args:@{@"module":@"GLImagePicker"}];
                                [weak_self hideLoadingToast];
//                                weak_self.tableView.hidden = ([groupArray count] == 0);
//                                [weak_self updateGroupArray:groupArray];
                                BOOL isShowSelectPage = [self.navigationController.topViewController isKindOfClass:[GLAssetsListViewController class]];
                                if (groupArray.count > 0 ) {
                                    [[GLImageGroupManager sharedInstance] updateCollectionArray:groupArray];
                                }
//                                [GLImageGroupManager sharedInstance].freshComplete = complete;
                                
                                if (weak_self.groupArray.count > 0 && groupArray.count> 0 && !isShowSelectPage) {
                                    //
                                    [weak_self pushAssetsViewControllerWithAssetGroup:[self.groupArray objectAtIndex:0] animated:NO];
                                } else {
                                    // 没有相册
                                    [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                                           arg1:@"prepareData"
                                                           arg2:@"s4"
                                                           arg3:@""
                                                           args:@{@"module":@"GLImagePicker",@"groupcount":@(groupArray.count)}];
                                }
                                [weak_self.tableView reloadData];
                            });
                        }];
                    });
                    
                    
                    // 获取其他相册
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                                   arg1:@"prepareData"
                                                   arg2:@"start-fetch-group"
                                                   arg3:@"phase2"
                                                   args:@{@"module":@"GLImagePicker"}];

                            [[GLFetchImageManager sharedInstance] fetchImageGroupHasVideo:NO
                                                                               withFetchType:GLFetchImageTypeExceptRecents
                                                                               completion:^(NSArray<GLFetchImageGroup *> *groupArray, BOOL complete) {
                                [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                                       arg1:@"prepareData"
                                                       arg2:@"s2-fetchgroup-ok"
                                                       arg3:@"phase2"
                                                       args:@{@"module":@"GLImagePicker",@"groupcount":@(groupArray.count)}];

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                                                           arg1:@"prepareData"
                                                           arg2:@"s3-main-queue"
                                                           arg3:@"phase2"
                                                           args:@{@"module":@"GLImagePicker"}];
    //                                weak_self.tableView.hidden = ([groupArray count] == 0);
    //                                [weak_self updateGroupArray:groupArray];
                                    if (groupArray.count > 0 ) {
                                        [[GLImageGroupManager sharedInstance] updateCollectionArray:groupArray];
                                    }
                                    [GLImageGroupManager sharedInstance].freshComplete = complete;

                                    if (complete) {
                                        [GLImageGroupManager sharedInstance].freshStatus = GLFetchGoupStatusComplete;
                                    }

                                });
                            }];
                        });
                    // ~~ 分阶段获取图片结束
                } else {
                    if (self.groupArray.count > 0) {
                        [self pushAssetsViewControllerWithAssetGroup:[self.groupArray objectAtIndex:0] animated:NO];
                    }
                }
            }
        }];
    }
}

- (void)updateGroupArray:(NSArray *)groupArray
{
    if (self.groupArray == nil) {
        self.groupArray = [NSMutableArray new];
    }
    [self.groupArray addObjectsFromArray:groupArray];
//    _groupArray = groupArray;
}
- (void)pushAssetsViewControllerWithAssetGroup:(GLFetchImageGroup *)group animated:(BOOL)animatedFlag
{
    [GLIPUTUtil commitTechEvent:@"GLAssetsGroupViewController"
                           arg1:@"pushAssetsViewControllerWithAssetGroup"
                           arg2:@"main-queue"
                           arg3:@""
                           args:@{@"module":@"GLImagePicker"}];
    
    GLAssetsListViewController *assetsListViewController = [[GLAssetsListViewController alloc] init];
    assetsListViewController.currentGroup = group;
    self.currentGroup = group;
    assetsListViewController.maxSelectedCount = self.maxSelectedCount;
    assetsListViewController.finishBlock = self.finishBlock;
    assetsListViewController.cancelBlock = self.cancelBlock;
    assetsListViewController.showGif = self.showGif;
	assetsListViewController.config = self.config;
    [self.navigationController pushViewController:assetsListViewController animated:animatedFlag];
}

#pragma mark- PHPhotoLibraryChangeObserver
-(void)photoLibraryDidChange:(PHChange *)changeInstance {
//    NSLog(@"************** photoLibraryDidChange!!");
    
    // 系统弹出权限选择时，新版会不在主线程了
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.currentGroup.data];
        if (collectionChanges == nil) {
            return;
        }
        
        // 照片有增减
        if ([[collectionChanges insertedIndexes] count] > 0 || [[collectionChanges removedIndexes] count]>0) {
            
            if ([self.navigationController.topViewController isKindOfClass:[GLAssetsListViewController class]]) {
                [self.navigationController popViewControllerAnimated:NO];
            }
            
            [self prepareData];
        } else {
            // 已经图片更新，如：从iCould下载图片
        }
    });
        
}

#pragma mark- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [GLAssetsGroupCell viewHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GLAssetsGroupCell";
    GLAssetsGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GLAssetsGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // data
    if (indexPath.row < _groupArray.count) {
        [cell fillData:[_groupArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _groupArray.count) {
        [self pushAssetsViewControllerWithAssetGroup:[_groupArray objectAtIndex:indexPath.row] animated:YES];
    }
}


- (void)checkAuthority {
    if ([PHPhotoLibrary respondsToSelector:@selector(authorizationStatusForAccessLevel:)]) {
        PHAuthorizationStatus status = [PHPhotoLibrary performSelector:@selector(authorizationStatusForAccessLevel:) withObject:@(2)];
        if (status == 4) {
            self.isLimitedStatus = YES;
        }
    }
}

- (void) adjustViews {
    [self checkAuthority];
    
    if (self.isLimitedStatus) {
        CGRect frameOfTableView = CGRectMake(0, limited_status_viewHeight, self.view.width, self.view.height);
        frameOfTableView.size.height = self.view.height - limited_status_viewHeight;
        self.tableView.frame = frameOfTableView;
        
        self.limitedStatusView.hidden = NO;
    } else {
        self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        if (self.limitedStatusView) {
            self.limitedStatusView.hidden = YES;
        }
    }
}


@end

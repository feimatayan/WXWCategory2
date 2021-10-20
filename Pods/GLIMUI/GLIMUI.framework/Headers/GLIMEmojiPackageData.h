//
//  GLIMEmojiPackageData.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/4.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GLIMEmojiType)
{
    GLIMEmojiNone,
    GLIMEmojiSmall,             // 小表情
    GLIMEmojiBig,               // 大表情
    GLIMEmojiCustomExpression,  // 自定义表情
};

typedef NS_ENUM(NSInteger, GLIMEmojiPackageStatus)
{
    GLIMEmojiPackageNone,           //
    GLIMEmojiPackageNotExist,       // 表情包不存在
    GLIMEmojiPackageDownloading,    // 表情包下载中
    GLIMEmojiPackageDownloadFailed, // 表情包下载失败
    GLIMEmojiPackageExistZip,       // 表情包下载完成，但未解压
    GLIMEmojiPackageExist,          // 表情包已解压
    GLIMEmojiPackageParsed,         // 表情包已经解析
    GLIMEmojiPackageNeedUpdate,     // 表情包有更新
};

@interface GLIMEmojiPackageData : NSObject

/// 表情包名
@property (nonatomic, strong) NSString *packageName;
/// 表情包图标
@property (nonatomic, strong) NSString *packageImage;
/// 表情包版本
@property (nonatomic, strong) NSString *packageVersion;
/// 表情包是否可用
@property (nonatomic, assign) BOOL packageEnable;

@property (nonatomic, assign) BOOL isNew;

/// 表情包类型
@property (nonatomic, assign) GLIMEmojiType emojiType;
/// 表情包内表情数据
@property (nonatomic, strong) NSMutableArray *emojiDataArray;

#pragma mark -
/// 表情包下载地址
@property (nonatomic, strong) NSString *packageUrl;
/// 表情包状态
@property (nonatomic, assign) GLIMEmojiPackageStatus packageStatus;

#pragma mark - 表情包是否显示badge
/// 是不是新增的表情包，YES - 是，默认为NO
@property (nonatomic, assign) BOOL isNewPacakge;
/// 表情包的badgeKey，用于表情包badge显隐藏状态的持久化
@property (nonatomic, strong) NSString *packageBadgeKey;

#pragma mark - UI显示数据
/// 每页显示行列
@property (nonatomic, assign, readonly) NSInteger pageRow;
@property (nonatomic, assign, readonly) NSInteger pageColumn;
/// 总共页数
@property (nonatomic, assign, readonly) NSInteger pageNumber;
/// 每页表情数
@property (nonatomic, assign, readonly) NSInteger emojiNumberPerPage;
/// emoji显示尺寸
@property (nonatomic, assign, readonly) float emojiWidth;
@property (nonatomic, assign, readonly) float emojiHeight;

- (instancetype)initWithEmojiType:(GLIMEmojiType)emojiType;

/// 获取指定页的表情数据
- (NSArray *)emojiDataArrayWithPageIndex:(NSInteger)pageIndex;

/// 仅更新一行显示个数
- (void)updatePageColumn:(NSInteger)pageColumn;

@end

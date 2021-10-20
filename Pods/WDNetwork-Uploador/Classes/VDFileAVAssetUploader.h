//
//  VDFileAVAssetUploader.h
//  WDNetwork-Uploador
//
//  Created by 杨鑫 on 2021/8/3.
//

#import <Foundation/Foundation.h>

#import "VDUploaderAVAssetProtocol.h"
#import "VDUploadResultDO.h"


@class WDNErrorDO;
@class AVAsset, AVAssetTrack;

@interface VDFileAVAssetUploader : NSObject

#pragma mark - AVAssetDelegate

+ (void)setIMAVAssetDelegate:(id<VDUploaderAVAssetProtocol>)imDelegate;

/// avAsset视频上传，买家版IM使用
///
/// @param videoPath 这不是最终上传的地址，这是本地播放的地址，需要压缩导出上传。也是缓存的key值
/// @param scope ''
/// @param progress 进度
/// @param compress 压缩成功，返回压缩地址，实际上传的地址。
/// @param complete ''
+ (void)UploadIMAVAssetBy:(NSString *)videoPath
                    scope:(NSString *)scope
                 progress:(void(^)(NSProgress *progress))progress
                 compress:(void(^)(NSString *exportPath))compress
                 complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete;

/// avAsset视频上传
///
/// @param asset AVAsset
/// @param scope ''
/// @param param {gifFps: 1~60, start:（0，视频时长], gifDuration:（0，视频时长]}
/// @param progress ''
/// @param complete
/// @param sessionId 可以不传
+ (void)UploadAVAsset:(AVAsset *)asset
                scope:(NSString *)scope
                param:(NSDictionary *)param
             progress:(void(^)(NSProgress *progress))progress
             complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
            sessionId:(NSString *)sessionId;

@end

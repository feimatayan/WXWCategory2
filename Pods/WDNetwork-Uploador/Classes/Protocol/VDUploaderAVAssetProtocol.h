//
//  VDUploaderAVAssetProtocol.h
//  Pods
//
//  Created by 杨鑫 on 2021/8/3.
//


@class VDUploadResultDO, WDNErrorDO;

@protocol VDUploaderAVAssetProtocol <NSObject>

@optional

/// avAsset视频上传
/// @param videoPath 这不是最终上传的地址，这是本地播放的地址，需要压缩导出上传。也是缓存的key值
/// @param scope ''
/// @param progress 进度
/// @param compress 压缩成功
/// @param complete ''
- (void)UploadIMAVAssetBy:(NSString *)videoPath
                    scope:(NSString *)scope
                 progress:(void(^)(NSProgress *progress))progress
                 compress:(void(^)(NSString *exportPath))compress
                 complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete;

@end


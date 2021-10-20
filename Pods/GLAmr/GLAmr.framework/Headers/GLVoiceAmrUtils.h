//
//  GLVoiceAmrUtils.h
//  iShoppingCommon
//
//  Created by jfzhao on 14-11-18.
//
//

#import <Foundation/Foundation.h>


@interface GLVoiceAmrUtils : NSObject

/*************************************************
 WAVE音频采样频率是8khz
 音频样本单元数 = 8000*0.02 = 160 (由采样频率决定)
 声道数  1 : 160
        2 : 160*2 = 320
 bps决定样本(sample)大小
        bps = 8 --> 8位 unsigned char
        16 --> 16位 unsigned short
*************************************************/
+ (BOOL)wavFileToArmFile:(NSString*)wavPath amrFile:(NSString*)savePath;


/*************************************************
 将AMR文件解码成WAVE文件
*************************************************/
+ (BOOL)armFileToWavFile:(NSString*)amrPath wavFile:(NSString*)savePath;

@end

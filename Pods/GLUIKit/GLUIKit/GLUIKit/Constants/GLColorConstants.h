//
//  GLColorConstants.h
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 20/02/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#ifndef GLColorConstants_h
#define GLColorConstants_h

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

// TC Text Color
#define     GLTC_Red_C60A1E                  UIColorFromRGB(0xC60A1E)
#define     GLTC_Red_EB4935                  UIColorFromRGB(0xEB4935)
#define     GLTC_Black_222222                UIColorFromRGB(0x222222)
#define     GLTC_Black_404040                UIColorFromRGB(0x404040)
#define     GLTC_Gray_737373                 UIColorFromRGB(0x737373)
#define     GLTC_Gray_9A9A9A                 UIColorFromRGB(0x9A9A9A)
#define     GLTC_Gray_CACACA                 UIColorFromRGB(0xCACACA)
#define     GLTC_Blue_4384D8                 UIColorFromRGB(0x4384D8)
#define     GLTC_Blue_6592CD                 UIColorFromRGB(0x6592CD)
#define     GLTC_Green_09BB07                UIColorFromRGB(0x09BB07)
#define     GLTC_Yellow_F69D00               UIColorFromRGB(0xF69D00)
#define     GLTC_White_FFFFFF                UIColorFromRGB(0xFFFFFF)

// VC View Color
#define     GLVC_Red_C60A1E                  UIColorFromRGB(0xC60A1E)
#define     GLVC_Red_EB4935                  UIColorFromRGB(0xEB4935)
#define     GLVC_Blue_4384D8                 UIColorFromRGB(0x4384D8)
#define     GLVC_Blue_6592CD                 UIColorFromRGB(0x6592CD)
#define     GLVC_Gray_DDDDDD                 UIColorFromRGB(0xDDDDDD)
#define     GLVC_Gray_F7F7F7                 UIColorFromRGB(0xF7F7F7)
#define     GLVC_Gray_EEEEEE                 UIColorFromRGB(0xEEEEEE)
#define     GLVC_Green_09BB07                UIColorFromRGB(0x09BB07)
#define     GLVC_Yellow_F69D00               UIColorFromRGB(0xF69D00)
#define     GLVC_Red_E9071F                  UIColorFromRGB(0xE9071F)

// VC Universal Color
#define     GLUC_Line                        GLVC_Gray_DDDDDD           // 线的颜色
#define     GLUC_Dot                         GLVC_Red_EB4935            // 红点
#define     GLUC_White                       GLTC_White_FFFFFF          // 白色
#define     GLUC_Clear                       [UIColor clearColor]
#define     GLUC_NAVBAR                      GLVC_Red_C60A1E


#endif /*  GLColorConstants_h */
